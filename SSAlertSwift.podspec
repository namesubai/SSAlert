

Pod::Spec.new do |s|
  s.name         = "SSAlertSwift"
  s.version      = "0.0.9"
  s.summary      = "快速构建弹窗"
  s.platform     = :ios, "9.0"
  s.swift_versions = "5.0"
  s.homepage     = "https://github.com/namesubai/SSAlert.git"
  s.author             = { "subai" => "804663401@qq.com" }
  s.source       = { :git => "https://github.com/namesubai/SSAlert.git", :tag => "#{s.version}"}
  s.license      = "MIT"
  s.source_files = "Sources/SSAlertSwift/**/*.swift"

end
