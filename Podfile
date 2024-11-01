workspace 'JNFoundationDemo.xcworkspace'
project 'JNFoundationDemo/JNFoundationDemo.xcodeproj'
project 'JNFoundation/JNFoundation.xcodeproj'

inhibit_all_warnings!
platform :ios, '12.0'

abstract_target 'CommonPods' do
  inhibit_all_warnings!
	use_frameworks!
  pod 'RxSwift', '5.1.1'
  pod 'RxCocoa', '5.1.1'
  pod 'SnapKit', '5.0.1'
  
  pod 'WCDB.swift', '2.0.4'
  pod 'CleanJSON', '1.0.6'

  target 'JNFoundationDemo' do
    project 'JNFoundationDemo/JNFoundationDemo.xcodeproj'
     use_frameworks!

      pod 'Alamofire', '4.9.1'
      pod 'CryptoSwift', '1.3.2'
  end
  
  target 'JNFoundation' do
    project 'JNFoundation/JNFoundation.xcodeproj'
        use_frameworks!
        
        pod 'CleanJSON', '1.0.6'
  end
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
      end
    end
  end
  
end
