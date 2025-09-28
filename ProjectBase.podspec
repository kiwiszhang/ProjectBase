Pod::Spec.new do |s|
  s.name             = 'ProjectBase'
  s.version          = '1.0.0'
  s.summary          = 'Base components and utilities for iOS projects.'
  s.description      = <<-DESC
  ProjectBase 提供了一套基础组件和工具方法，包括：
  - 常用的 UI 扩展
  - 工具类（通知管理、设备方向控制）
  - 自定义视图
  方便快速搭建 iOS 项目基础框架。
  DESC
  s.homepage         = 'https://github.com/kiwiszhang/ProjectBase'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'kiwiszhang' => 'zhangzhiqiang.mail@qq.com' }
  s.source           = { :git => 'https://github.com/kiwiszhang/ProjectBase.git', :tag => s.version.to_s }

  # ✅ Pod 最低支持 iOS 12，防止 libarclite 问题
  s.ios.deployment_target = '15.0'

  # ✅ Swift 版本
  s.swift_versions   = '5'

  # 代码文件
  s.source_files     = 'Sources/**/*.{swift,h,m}'

  # 资源文件
  s.resource_bundles = {
    'ProjectBaseResources' => ['Sources/Resources/**/*.{xcassets,imageset,png,jpg,json,plist}']
  }

  # 依赖库（使用支持 iOS 12+ 的最新版本）
  s.dependency 'SnapKit', '~> 5.7.0'
  s.dependency 'MBProgressHUD', '~> 0.9.2'
  s.dependency 'Localize-Swift', '~> 3.2.0'

  # ✅ 强制覆盖自己 Pod 的 Deployment Target
  s.pod_target_xcconfig = {
    'IPHONEOS_DEPLOYMENT_TARGET' => '15.0'
  }
  s.user_target_xcconfig = {
    'IPHONEOS_DEPLOYMENT_TARGET' => '15.0'
  }
end




# pod cache clean --all
# rm -rf ~/Library/Developer/Xcode/DerivedData/*
# pod repo update
# pod lib lint ProjectBase.podspec --no-clean --verbose
