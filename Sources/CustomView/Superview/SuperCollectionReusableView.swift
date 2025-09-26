//
//  SuperCollectionReusableView.swift
//  MobileProgect
//
//  Created by csqiuzhi on 2019/5/8.
//  Copyright © 2019 于晓杰. All rights reserved.
//

import UIKit

class SuperCollectionReusableView: UICollectionReusableView {
    //MARK: ----------初始化方法-----------
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
}
//MARK: ----------UI-----------
extension SuperCollectionReusableView {
    @objc func setUpUI() {
        backgroundColor(.clear)
    }
}

