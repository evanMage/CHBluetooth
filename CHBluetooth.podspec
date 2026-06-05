
Pod::Spec.new do |spec|

  spec.name         = "CHBluetooth"
  
  spec.version      = "1.0.5"
  
  spec.summary      = "轻松使用BLE在iOS设备之间通信。"
  
  spec.homepage     = "https://github.com/evanMage/CHBluetooth"
  
  spec.license      = "MIT"

  spec.author    = "evan"

  spec.ios.deployment_target = "10.0"
  spec.osx.deployment_target = "11.0"
  spec.watchos.deployment_target = "9.0"
  
  spec.swift_versions = "5.0"
  
  spec.source       = { :git => "https://github.com/evanMage/CHBluetooth.git", :tag => spec.version }

  spec.source_files = "Sources/**/*.swift"
  
end
