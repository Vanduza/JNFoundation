//
//  StorableModel.swift
//  JNFoundation
//
//  Created by 杨敬 on 2020/6/28.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation
import RxSwift

public enum JNCacheError: Error {
    case Timeout
}

public protocol ModelItem: Equatable, Codable {
    init()
    func getId() -> String
    func beforeMerge()
    func afterMerge()

    var updateTime: Int { get }
}

public extension ModelItem {
    func beforeMerge() {}
    func afterMerge() {}
    var updateTime: Int {
        return 0
    }
}

public extension ModelItem where Self: AnyObject {
    func getId() -> String? {
        fatalError("ModelItem must be struct")
    }
    func beforeMerge() {
        fatalError("ModelItem must be struct")
    }
    func afterMerge() {
        fatalError("ModelItem must be struct")
    }

    var updateTime: Int {
        fatalError("ModelItem must be struct")
    }
}

public protocol StorableModel: Model, ModelAble {
    associatedtype Item: ModelItem
    associatedtype ChangedEvent: ModelEvent
    func setItems(_ items: [Item], strategy: MergeStrategy, post: Bool) -> [String]
    func setItem(_ item: Item, strategy: MergeStrategy, post: Bool) -> Bool

    func getItem(id: String) -> Item?
    func getItems(ids: String) -> Observable<[Item]>

    func loadFromDB(id: String) -> Item?
    func loadFromDB(ids: [String]) -> [Item]

    func saveToDB(item: Item) -> Bool
    func saveToDB(items: [Item]) -> [String]

    func clearCacheAndDB()

    var lock: NSRecursiveLock { get }
    var condition: NSCondition { get }

    var cache: [String: Item] { get set }
    var cacheStrategy: CacheStrategy { get }
    var writing: Set<String> {get set}
}

public extension StorableModel {

    func loadFromDBForMerge(ids: [String]) -> [Item] {
        return loadFromDB(ids: ids)
    }

    func clearCacheAndDB() {
        cacheStrategy.clear()
        cache.removeAll()
        clearAllDataInDB()
    }

    var cacheStrategy: CacheStrategy {
        return NoCacheStrategy()
    }

    func postEvent(_ ids: [String]) {
        nc.post(ChangedEvent.init(ids: ids))
    }

    func setItems(_ items: [Item], strategy: MergeStrategy = JoinMergeStrategy(), post: Bool = false) -> [String] {
        return setImpl(items: items, withStrategy: strategy, post: post)
    }

    func setItem(_ item: Item, strategy: MergeStrategy = JoinMergeStrategy(), post: Bool = false) -> Bool {
        return setImpl(item: item, withStrategy: strategy, post: post)
    }
}

extension StorableModel {
    fileprivate func setImpl(item: Item, withStrategy strategy: MergeStrategy, post: Bool) -> Bool {

        let ids = [item.getId()]
        do {
            try waitForWriting(ids: ids)
        } catch JNCacheError.Timeout {
            print("set item:{ \(item) } timeout")
            writeOver(ids: ids)
            return false
        } catch {
            print("set item:{ \(item) } unkonw error")
            writeOver(ids: ids)
            return false
        }
        lock.lock()
        var old = cache[item.getId()]
        lock.unlock()
        if old != nil && old!.updateTime > item.updateTime {
            return true
        }

        if old == nil {
            let olds = loadFromDB(ids: ids)
            old = olds.first
        }

        if old == nil {
            old = Item()
        }

        old?.beforeMerge()
        item.beforeMerge()
        let changed = strategy.mergeToOld(old: &old!, new: item)
        old?.afterMerge()

        if !saveToDB(item: old!) {
            writeOver(ids: ids)
            return false
        }

        lock.lock()
        cache[old!.getId()] = old
        let elimiIds = cacheStrategy.adjust(byNewData: ids)
        for id in elimiIds {
            cache.removeValue(forKey: id)
        }
        lock.unlock()

        writeOver(ids: ids)

        if changed && post {
            postEvent(ids)
        }

        return true
    }

    fileprivate func setImpl(items: [Item], withStrategy strategy: MergeStrategy, post: Bool) -> [String] {

        var idsSet: Set<String> = []
        var ids = [String]()
        var itemMap = [String: Item]()

        for item in items {
            if idsSet.contains(item.getId()) {
                continue
            }

            let id = item.getId()

            idsSet.insert(id)
            ids.append(id)
            itemMap[id] = item
        }

        var oldMap = [String: Item]()
        var changeds = [String]()
        var failed = [String]()

        var left = [String]()

        do {
            try self.waitForWriting(ids: ids)
        } catch JNCacheError.Timeout {
            JPrint("set ids:{ \(ids) } timeout")
            self.writeOver(ids: ids)
        } catch {
            JPrint("set ids:{ \(ids) } unkonw error")
            self.writeOver(ids: ids)
        }

        self.getWithLock(ids: ids, result: &oldMap, left: &left)

        var dbs: [String: Item] = [:]
        for it in self.loadFromDBForMerge(ids: left) {
            dbs[it.getId()] = it
        }
        for id in left {
            let old = dbs[id]
            if old == nil {
                oldMap[id] = Item()
            } else {
                oldMap[id] = old!
            }
        }

        // merge
        for id in ids {
            guard let new = itemMap[id] else {
                continue
            }

            var old = oldMap[id]!
            // 因为如果没有使用updateTime 则全部为0，所以相等也需要更新
            if old.updateTime > new.updateTime {
                oldMap.removeValue(forKey: id)
                continue
            }
            new.beforeMerge()
            old.beforeMerge()
            let changed = strategy.mergeToOld(old: &old, new: new)
            old.afterMerge()
            if changed {
                changeds.append(id)
                oldMap.updateValue(old, forKey: id)
            } else {
                oldMap.removeValue(forKey: id)
            }
        }

        let result = self.saveToDB(items: Array(oldMap.values))
        failed.append(contentsOf: result)
        for id in result {
            oldMap.removeValue(forKey: id)
        }

        //adjust cache
        self.lock.lock()
        let elimi = self.cacheStrategy.adjust(byNewData: ids)
        for id in elimi {
            self.cache.removeValue(forKey: id)
            oldMap.removeValue(forKey: id)
        }
        self.cache.merge(oldMap, uniquingKeysWith: { (_, new) -> Item in
            return new
        })
        self.lock.unlock()

        self.writeOver(ids: ids)

        if post && changeds.count != 0 {
            self.postEvent(changeds)
        }
        return ids
    }

    fileprivate func waitForWriting(ids: [String])throws {
        condition.lock()
        defer {
            condition.unlock()
        }
        var wait = true
        while wait {
            wait = false
            for id in ids {
                if writing.contains(id) {
                    wait = true
                    break
                }
            }

            if wait {
                let suc = condition.wait(until: Date(timeIntervalSinceNow: 5/*s*/))
                if !suc {
                    throw JNCacheError.Timeout
                }
            }
        }

        writing.formUnion(ids)
    }

    fileprivate func writeOver(ids: [String]) {
        condition.lock()
        defer {
            condition.unlock()
        }

        for id in ids {
            writing.remove(id)
        }
        condition.broadcast()

    }

    fileprivate func getWithLock(ids: [String], result: inout [String: Item], left: inout [String]) {

        lock.lock()
        defer {lock.unlock();}
        for id in ids {
            guard let old = cache[id] else {
                left.append(id)
                continue
            }

            result[id] = old
        }
    }
}
