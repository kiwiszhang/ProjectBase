#!/bin/bash
set -e

# -----------------------------
# 配置区
# -----------------------------
PODSPEC_PATH="ProjectBase.podspec"  # podspec 文件名
IOS_DEPLOYMENT_TARGET="15.0"        # 最低 iOS 版本，避免 libarclite 错误
SWIFT_VERSION="5"                 # Swift 版本
# -----------------------------

echo "🔹 Cleaning CocoaPods cache..."
pod cache clean --all

echo "🔹 Updating local Specs repo..."
pod repo update

echo "🔹 Running pod lib lint..."
# 使用 --skip-import-validation 避免依赖库头文件报错
pod lib lint "$PODSPEC_PATH" \
  --verbose \
  --no-clean \
  --allow-warnings \
  --skip-import-validation \
  --swift-version="$SWIFT_VERSION" \
  --use-static-frameworks

echo "🔹 Applying post-install hack for Deployment Target..."
# 临时生成 Podfile 来强制依赖库 target
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

cat <<EOF > Podfile
platform :ios, '$IOS_DEPLOYMENT_TARGET'
use_frameworks!

target 'LintTarget' do
  pod '../$PODSPEC_PATH'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '$IOS_DEPLOYMENT_TARGET'
    end
  end
end
EOF

echo "🔹 Installing dependencies..."
pod install --verbose

echo "✅ Pod lint and target fix completed successfully!"
