#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint ai_amap.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'ai_amap'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin about amap.'
  s.description      = <<-DESC
A new Flutter plugin about amap.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  # (https://lbs.amap.com/api/ios-sdk/guide/create-project/cocoapods)
#  s.dependency 'AMap3DMap'
#  s.dependency 'AMapSearch'
  s.dependency 'AMapLocation'
  # （AMapNavi 已包含3D地图，无需单独引入3D地图）
  s.dependency 'AMapNavi'
  s.static_framework = true
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
end
