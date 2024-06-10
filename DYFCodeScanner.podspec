
Pod::Spec.new do |s|
  s.name         = "DYFCodeScanner"
  s.version      = "1.3.0"
  s.summary      = "A simple QRcode and barcode scanner."
  s.description  = <<-DESC
  A simple QRcode and barcode scanner, which has a set of custom scanning animation and interface, supports camera zooming, and can generate and identify QR code.
  DESC

  s.homepage     = "https://github.com/itenfay/DYFCodeScanner"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = { "Tenfay" => "hansen981@126.com" }

  s.platform     = :ios
  s.ios.deployment_target 	= "8.0"
  # s.osx.deployment_target 	= "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target 	= "9.0"

  s.source       = { :git => "https://github.com/itenfay/DYFCodeScanner.git", :tag => s.version.to_s }

  s.source_files  = "Classes/**/*.{h,m}"
  s.public_header_files = "Classes/**/*.h"

  # s.resource  = "icon.png"
  s.resources = "Resource/*.bundle"

  s.frameworks = "Foundation", "UIKit", "CoreGraphics", "AVFoundation", "CoreImage"
  # s.libraries = "iconv", "xml2"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"
end
