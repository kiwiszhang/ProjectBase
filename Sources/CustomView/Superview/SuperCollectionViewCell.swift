//
//  SuperCollectionViewCell.swift
//  MobileProgect
//
//  Created by csqiuzhi on 2019/5/7.
//  Copyright © 2019 于晓杰. All rights reserved.
//

import UIKit
import Localize_Swift

class SuperCollectionViewCell: UICollectionViewCell {
    //MARK: ----------懒加载-----------
    override init(frame: CGRect) {
        super.init(frame: frame)
        NotificationCenter.default.addObserver(self, selector: #selector(updateLanguageUI), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        setUpUI()
        getData()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        NotificationCenter.default.addObserver(self, selector: #selector(updateLanguageUI), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        setUpUI()
        getData()
    }
    var collectionView: UICollectionView {
        get {
            var collectionView = superview
            while collectionView != nil && collectionView!.isKind(of: UICollectionView.classForCoder()) {
                collectionView = collectionView?.superview
            }
            return collectionView as! UICollectionView
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
        getData()
    }
}
//MARK: ----------UI-----------
extension SuperCollectionViewCell {
    @objc func setUpUI() {
        if #available(iOS 14.0, *) {
            backgroundConfiguration = UIBackgroundConfiguration.clear()
        }
        backgroundColor(.clear)
    }
    @objc func getData(){
        
    }
}
//MARK: ----------切换语言-----------
extension SuperCollectionViewCell {
    @objc func updateLanguageUI() {
        // 子类重写此方法实现具体更新逻辑
    }
}
