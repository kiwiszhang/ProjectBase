//
//  CustomTabBarController.swift
//  MobileProject
//
//  Created by 笔尚文化 on 2025/8/13.
//

import VisionKit
import UIKit
import Vision
import Localize_Swift


class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(updateLanguageUI), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        // 替换系统 TabBar
        let customTabBar = CustomTabBar()
        setValue(customTabBar, forKey: "tabBar")
        
        // 添加子控制器
        viewControllers = [
            createNav(ExpendViewController(), title: L10n.tabExpense, image: Asset.expendsUnselected.image, selectedImage: Asset.expends.image),
            createNav(ReportsViewController(), title: L10n.tabReports, image: Asset.reportUnselected.image, selectedImage: Asset.report.image),
            createNav(SummaryViewController(), title: L10n.tabSummary, image: Asset.summaryUnselected.image, selectedImage: Asset.summary.image),
            createNav(SettingViewController(), title: L10n.tabSetting, image: Asset.settingUnselected.image, selectedImage: Asset.setting.image)
        ]
        
        // 中间按钮点击
        if let customTabBar = tabBar as? CustomTabBar {
            customTabBar.centerButton.addTarget(self, action: #selector(centerButtonTapped), for: .touchUpInside)
        }
    }
    
    private func createNav(_ rootVC: UIViewController, title: String, image: UIImage, selectedImage: UIImage) -> UINavigationController {
        let nav = CustomNavigationController(rootViewController: rootVC)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image.withRenderingMode(.alwaysOriginal)
        nav.tabBarItem.selectedImage = selectedImage.withRenderingMode(.alwaysOriginal)
        return nav
    }
    @objc func updateLanguageUI() {
        // 遍历每个 tab
        for (index, item) in (self.tabBar.items ?? []).enumerated() {
            switch index {
            case 0:
                item.title = L10n.tabExpense  // 这里用你本地化的字符串
            case 1:
                item.title = L10n.tabReports
            case 2:
                item.title = L10n.tabSummary
            case 3:
                item.title = L10n.tabSetting
            default:
                break
            }
        }
        
        // 如果是 UINavigationController 包含的 ViewController，需要更新 root view controller 的标题
        if let navControllers = self.viewControllers as? [UINavigationController] {
            for nav in navControllers {
                nav.topViewController?.title = nav.topViewController?.title // 可以根据需要更新标题
            }
        }
    }
    @objc private func centerButtonTapped() {
        print("中间按钮点击了")
//        let documentCameraViewController = VNDocumentCameraViewController()
//        documentCameraViewController.delegate = self
//        present(documentCameraViewController, animated: true)
        
        let actionSheet = UIAlertController(title: L10n.selecteCreationMethod, message: nil, preferredStyle: .actionSheet)
        
        let sheet01 = UIAlertAction(title: L10n.singleReceiptScan, style: .default, handler: { [self] _ in
            UserDefaultsTools.isSingleReceipt = 0
            let scannerVC = ScannerViewController()
            scannerVC.view.backgroundColor = .white
            scannerVC.modalPresentationStyle = .overFullScreen
            self.present(scannerVC, animated: true)
        })
        sheet01.setValue(kkColorFromHex(kkMainColor), forKey: "titleTextColor")
        actionSheet.addAction(sheet01)
        
        let sheet02 = UIAlertAction(title: L10n.multipleReceiptsScan, style: .default, handler: { [self] _ in
            UserDefaultsTools.isSingleReceipt = 1
            let scannerVC = ScannerViewController()
            scannerVC.view.backgroundColor = .white
            scannerVC.modalPresentationStyle = .overFullScreen
            self.present(scannerVC, animated: true)
        })
        sheet02.setValue(kkColorFromHex(kkMainColor), forKey: "titleTextColor")
        actionSheet.addAction(sheet02)
        
        let sheet03 = UIAlertAction(title: L10n.manuallyCreate, style: .default, handler: { [self] _ in
            let content = ManuallypopViewController(entrytype: .addIcon)
            let popup = PopupContainerViewController(contentVC: content, height: kkScreenHeight - 60.h)
            content.dismissAction = {
                popup.dismissSelf()
            }
            present(popup, animated: false)
            
        })
        sheet03.setValue(kkColorFromHex(kkMainColor), forKey: "titleTextColor")
        actionSheet.addAction(sheet03)
        
        let cancel = UIAlertAction(title: L10n.cancel, style: .cancel, handler: nil)
        cancel.setValue(kkColorFromHex(kkMainColor), forKey: "titleTextColor")
        actionSheet.addAction(cancel)
        kkKeyWindow()?.rootViewController!.present(actionSheet, animated: true, completion: nil)
        
        
    }
}

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        UIView.setAnimationsEnabled(false)
        DispatchQueue.main.async {
            UIView.setAnimationsEnabled(true)
        }
    }
}

/// 设置tabbar push和pop回来选中颜色不会变
func setupTabBarAppearance() {
    let appearance = UITabBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = .white
    // 隐藏顶部的分隔线
    appearance.shadowColor = .clear   // iOS 13+
    appearance.shadowImage = UIImage() // 保险
    // 未选中状态
    appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
        .foregroundColor: kkColorFromHex("#A4A9B1")
    ]
    // 选中状态
    appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
        .foregroundColor: kkColorFromHex("#202124")
    ]
    UITabBar.appearance().standardAppearance = appearance
    if #available(iOS 15.0, *) {
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

///状态栏设置
extension MainTabBarController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return selectedViewController?.customStatusBarStyle ?? StatusBarManager.shared.style
//        return .darkContent
    }

    override var prefersStatusBarHidden: Bool {
        return selectedViewController?.customStatusBarHidden ?? StatusBarManager.shared.isHidden
    }

    override var childForStatusBarStyle: UIViewController? {
        return selectedViewController
    }
}
