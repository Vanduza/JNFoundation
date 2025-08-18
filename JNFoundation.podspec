#
#  Be sure to run `pod spec lint JNFoundation.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  spec.name         = "JNFoundation"
  spec.version      = "0.2.1"
  spec.summary      = "一个集成网络和DB的便捷工具库"
  spec.description  = <<-DESC
	JNFoundation是业务模块化的前期解耦合设计方案，将Net、DB、Model职责划分，为独立业务模块提供底层支持
                   DESC

  spec.homepage     = "https://github.com/Vanduza/JNFoundation"
  spec.license      = "MIT"
  spec.platform     = :ios
  spec.ios.deployment_target = "12.0"
  spec.swift_versions = "5.9"

  spec.author             = { "Vanduza" => "vanduza@163.com" }
  spec.source  = {:git => "https://github.com/Vanduza/JNFoundation.git", :tag => "V#{spec.version}"}
  spec.source_files  = "Sources/JNFoundation/**/{*.swift,*.h}"

  spec.dependency "WCDB.swift"
  spec.dependency "CleanJSON"
  spec.dependency "RxSwift"
  spec.dependency "RxCocoa"
end
