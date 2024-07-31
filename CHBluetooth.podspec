
Pod::Spec.new do |spec|

  spec.name         = "CHBluetooth"
  
  spec.version      = "0.0.2"
  
  spec.summary      = "轻松使用BLE在iOS设备之间通信。"
  
  spec.homepage     = "https://github.com/evanMage/CHBluetooth"
  
  spec.license      = "MIT"

  spec.author    = "evan"

  spec.ios.deployment_target = "10.0"
  
  spec.swift_versions = "5.0"
  
  spec.source       = { :git => "https://github.com/evanMage/CHBluetooth.git", :tag => spec.version }

  spec.source_files = "CHBluetooth/BLE/*.swift"
  
end
