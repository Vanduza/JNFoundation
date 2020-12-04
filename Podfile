workspace 'JNFoundationDemo.xcworkspace'
project 'JNFoundationDemo/JNFoundationDemo.xcodeproj'
project 'JNFoundation/JNFoundation.xcodeproj'

platform :ios, '10.0'
inhibit_all_warnings!
abstract_target 'CommonPods' do
	use_frameworks!
  pod 'RxSwift', '5.1.1'
  pod 'RxCocoa', '5.1.1'
  pod 'SnapKit', '5.0.1'
  
  pod 'WCDB.swift', '1.0.8.2'

  target 'JNFoundationDemo' do
    project 'JNFoundationDemo/JNFoundationDemo.xcodeproj'
     use_frameworks!

      pod 'Alamofire', '4.9.1'
      pod 'CryptoSwift', '0.15.0'
  end
  
  target 'JNFoundation' do
    project 'JNFoundation/JNFoundation.xcodeproj'
        use_frameworks!
        
        pod 'CleanJSON', '1.0.6'
  end
  
end
