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
  spec.version      = "0.2.0"
  spec.summary      = "A short description of JNFoundation."
  spec.summary      = "A short description of JNFoundation."
  spec.description  = <<-DESC
	JNFoundation
                   DESC

  spec.homepage     = "http://www.vanduza.com/JNFoundation"
  spec.license      = "MIT"
  spec.platform     = :ios, "10.0"

  spec.author             = { "Vanduza" => "vanduza@163.com" }
  spec.source  = {:git => "https://github.com/Vanduza/JNFoundation.git", :tag => "V#{spec.version}"}
  spec.source_files  = "JNFoundation/JNFoundation/**/*.swift","JNFoundation/JNFoundation/*.h","JNFoundation/JNFoundation/**/**/*.swift"

  spec.dependency "WCDB.swift", "1.0.8.2"
  spec.dependency "CleanJSON", "1.0.6"
  spec.dependency "RxSwift"
  spec.dependency "RxCocoa"
end
