workspace 'JNFoundationDemo.xcworkspace'
project 'JNFoundationDemo/JNFoundationDemo.xcodeproj'
project 'JNFoundation/JNFoundation.xcodeproj'

platform :ios, '10.0'
inhibit_all_warnings!
abstract_target 'CommonPods' do
	use_frameworks!
	pod 'SnapKit', '4.2.0'
  pod 'RxSwift', '4.5.0'
  pod 'RxCocoa', '4.5.0'
  
  pod 'CleanJSON', '1.0.1'
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
  
        pod 'WCDB.swift', '1.0.8.2'
        pod 'CleanJSON', '1.0.1'
  end
  
end
