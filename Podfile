workspace 'JNFoundationDemo.xcworkspace'
project 'JNFoundationDemo/JNFoundationDemo.xcodeproj'
project 'JNFoundation/JNFoundation.xcodeproj'

platform :ios, '10.0'
inhibit_all_warnings!
abstract_target 'CommonPods' do
	use_frameworks!
	pod 'SnapKit'
  pod 'RxSwift'
  pod 'RxCocoa'

  target 'JNFoundationDemo' do
    project 'JNFoundationDemo/JNFoundationDemo.xcodeproj'
     use_frameworks!

      pod 'SnapKit'
      pod 'Alamofire'
  end
  
  target 'JNFoundation' do
    project 'JNFoundation/JNFoundation.xcodeproj'
        use_frameworks!
  
        pod 'WCDB.swift'
        pod 'CleanJSON'
  end
  
end
