Pod::Spec.new do |s|
  s.name             = 'AccessibilitySnapshot+SnapshotTesting'
  s.version          = '0.1.0'
  s.summary          = 'Easy regression testing for iOS accessibility'

  s.homepage         = 'https://github.com/Sherlouk/AccessibilitySnapshot-SnapshotTesting'
  s.license          = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.authors          = 'Sherlouk'
  s.source           = { :git => 'https://github.com/Sherlouk/AccessibilitySnapshot-SnapshotTesting.git', :tag => s.version.to_s }

  s.swift_version = '5.0.1'

  s.ios.deployment_target = '10.0'

  s.source_files = 'AccessibilitySnapshot/Pointfree/Classes/**/*.{swift,h,m}'
  s.dependency 'AccessibilitySnapshot/Core'
  s.dependency 'SnapshotTesting', '~> 1.7.2'

  s.frameworks = 'XCTest'
  s.weak_frameworks = 'XCTest'
end
