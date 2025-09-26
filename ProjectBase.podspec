Pod::Spec.new do |s|
  s.name             = 'ProjectBase'
  s.version          = '1.0.0'
  s.summary          = 'A base iOS project library.'
  s.description      = <<-DESC
                        ProjectBase is a foundational library for iOS projects,
                        including custom UI components, helpers, and base classes.
                       DESC
  s.homepage         = 'https://github.com/kiwiszhang/ProjectBase'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'kiwiszhang' => 'your_email@example.com' }
  s.source           = { :git => 'https://github.com/kiwiszhang/ProjectBase.git', :tag => s.version }
  s.ios.deployment_target = '13.0'
  s.swift_version    = '5.0'
  s.source_files     = 'Sources/**/*.{h,m,swift}'
  
  # 添加依赖
  s.dependency 'SnapKit'
  s.dependency 'Localize-Swift'
end
