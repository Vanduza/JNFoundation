# JNFoundation

[![Version](https://img.shields.io/cocoapods/v/JNFoundation.svg?style=flat)](https://cocoapods.org/pods/JNFoundation)
[![License](https://img.shields.io/cocoapods/l/JNFoundation.svg?style=flat)](https://cocoapods.org/pods/JNFoundation)
[![Platform](https://img.shields.io/cocoapods/p/JNFoundation.svg?style=flat)](https://cocoapods.org/pods/JNFoundation)

JNFoundation是一个业务模块化的前期解耦合设计方案，将Net、DB、Model职责划分，为独立业务模块提供底层支持。它集成了网络请求、数据库操作、模型管理和对象化通知系统，为iOS应用提供统一的架构基础。

## 特性

- 🚀 **模块化架构**: 基于Plugin的模块化设计，支持业务模块解耦
- 🌐 **网络请求**: 基于RxSwift的响应式网络请求框架，支持Token管理和401处理
- 💾 **数据库管理**: 基于WCDB.swift的数据库操作，支持表版本管理和数据迁移
- 📱 **模型工厂**: 统一的模型管理，支持缓存策略和数据合并
- 🔔 **对象化通知**: 类型安全的事件通知系统，替代传统NotificationCenter
- 🔒 **数据安全**: 支持数据库加密和用户隔离

## 安装

### CocoaPods

```ruby
pod 'JNFoundation'
```

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/Vanduza/JNFoundation.git", from: "0.2.1")
]
```

## 快速开始

### 1. 初始化Plugin

```swift
class MyPluginName: Plugin.Name {
    static let shared: MyPluginName = MyPluginName()
    static let BaseUrl = "https://api.example.com/"
    
    func setup() {
        do {
            try Plugin.register(pluginName: self)
        } catch {
            print("Plugin注册失败: \(error)")
        }
        
        // 设置主网络
        let mainNet = Net(plugin: self.getPlugin(), baseUrl: MyPluginName.BaseUrl)
            .setToMainNet()
            .setHttpBuilder(YourHttpBuilder())
        self.getPlugin().setMainNet(mainNet)
    }
    
    func getPlugin() -> Plugin {
        guard let plugin = Plugin.getBy(name: self) else {
            fatalError("请先调用 setup() 方法")
        }
        return plugin
    }
}
```

### 2. API构建方式

JNFoundation提供了统一的API构建模式，支持请求/响应类型安全：

```swift
// 定义API
final class LoginAPI: MyAPI, MyAPIable {
    var request: Request
    var response: Response?
    
    init(req: Request) {
        self.request = req
    }
    
    func getUrl() -> String {
        return "login"
    }
    
    // 请求模型
    class Request: APIRequest {
        private let user_name: String
        private let password: String
        
        init(userName: String, pwd: String) {
            self.user_name = userName
            self.password = pwd
        }
    }
    
    // 响应模型
    class Response: APIResponse {
        let data: UserEntity
    }
    
    struct UserEntity: Decodable {
        let user_id: Int
        let token: String
    }
}

// 使用API
let loginAPI = LoginAPI(req: .init(userName: "user", pwd: "password"))
loginAPI.send()
    .subscribe(onNext: { api in
        guard let response = api.response else { return }
        print("登录成功: \(response.data.token)")
    }, onError: { error in
        print("登录失败: \(error)")
    })
    .disposed(by: disposeBag)
```

### 3. 数据库建表方式

基于WCDB.swift的数据库操作，支持类型安全的表定义：

```swift
// 定义表
class UserTable: TableAble {
    var db: Database
    
    init(db: Database) {
        self.db = db
    }
    
    // 数据库实体
    struct Entity: TableCodable {
        var id: String
        var name: String
        var gender: Int
        
        enum CodingKeys: String, CodingTableKey {
            typealias Root = Entity
            static let objectRelationalMapping = TableBinding(CodingKeys.self) {
                BindColumnConstraint(id, isPrimary: true)
            }
            case id, name, gender
        }
    }
    
    // 数据操作方法
    func setItems(_ items: [Entity]) -> Bool {
        do {
            try db.insertOrReplace(items, intoTable: self.name)
            return true
        } catch {
            print("数据库操作失败: \(error)")
            return false
        }
    }
    
    func getItem(by id: String) -> Entity? {
        return try? db.getObject(fromTable: self.name, where: Entity.Properties.id == id)
    }
}
```

### 4. 模型管理

通过ModelFactory统一管理业务模型：

```swift
class UserModel: Model, ModelAble {
    
    // 网络请求
    func login(userName: String, password: String) -> Observable<LoginAPI> {
        return LoginAPI(req: .init(userName: userName, pwd: password)).send()
    }
    
    // 数据库操作
    func getAllTables() -> [Table] {
        return [_table]
    }
    
    private lazy var _table = UserTable(db: self.selfDB)
    
    func setItem(_ item: Item) -> Bool {
        let entity = item.toEntity()
        return _table.setItems([entity])
    }
    
    func getItem(by id: String) -> UserModel.Item? {
        return _table.getItem(by: id)?.toItem()
    }
}

// 使用模型
let userModel = MyPluginName.shared.getMf().getModel(UserModel.self)
userModel.login(userName: "user", password: "password")
    .subscribe(onNext: { api in
        // 处理登录结果
    })
    .disposed(by: disposeBag)
```

### 5. 对象化通知使用

类型安全的事件通知系统，替代传统NotificationCenter：

```swift
// 定义事件
class LoginEvent: Event {
    let token: String
    let userId: Int
    
    init(token: String, userId: Int) {
        self.token = token
        self.userId = userId
    }
}

// 发送通知
let event = LoginEvent(token: "abc123", userId: 1001)
MyPluginName.shared.getNc().post(event)

// 监听通知
MyPluginName.shared.getNc().observeEvent { (event: LoginEvent) in
    print("收到登录事件: token=\(event.token), userId=\(event.userId)")
}.disposed(by: disposeBag)

// 监听多个事件
MyPluginName.shared.getNc().observeEvents([LoginEvent.self, LogoutEvent.self]) {
    print("收到登录或登出事件")
}.disposed(by: disposeBag)
```

## 核心组件

### Plugin系统
- **Plugin**: 模块化基础，管理网络、数据库、模型工厂和通知中心
- **Plugin.Name**: 插件标识符，支持Hashable协议
- **线程安全**: 使用并发队列管理插件注册和获取

### 网络层 (Net)
- **API协议**: 统一的API接口定义
- **Token管理**: 自动处理Token获取、存储和401错误
- **响应式**: 基于RxSwift的Observable模式
- **错误处理**: 完善的错误类型和处理机制

### 数据库层 (DB)
- **TableAble**: 表定义协议，支持版本管理
- **WCDB集成**: 基于WCDB.swift的ORM
- **数据隔离**: 支持用户数据隔离和共享数据
- **版本控制**: 自动处理数据库升级

### 模型层 (Model)
- **ModelFactory**: 模型工厂，统一管理业务模型
- **缓存策略**: 支持LRU、LFU等缓存策略
- **数据合并**: 支持多种数据合并策略
- **生命周期**: 自动管理模型生命周期

### 通知系统 (NC)
- **类型安全**: 基于泛型的事件系统
- **主线程**: 确保事件发送在主线程
- **内存管理**: 自动处理观察者生命周期

## 依赖

- iOS 12.0+
- Swift 5.9+
- WCDB.swift
- CleanJSON
- RxSwift

## 许可证

JNFoundation基于MIT许可证开源。详见[LICENSE](LICENSE)文件。

## 贡献

欢迎提交Issue和Pull Request来改进JNFoundation。

## 联系方式

- 作者: Vanduza
- 邮箱: vanduza@163.com
- GitHub: [https://github.com/Vanduza/JNFoundation](https://github.com/Vanduza/JNFoundation)