//
//  UIButton+Create.swift
//  MobileProject
//
//  Created by Yu on 2025/4/4.
//

import UIKit

extension UIButton {
    //单独每个项目写一个
    @discardableResult
    func hnFont(size: CGFloat, weight: InterWeight = .regular) -> Self {
        titleLabel?.font = UIFont.inter(size: size, weight: weight)
        return self
    }

    @discardableResult
    func title(_ text: String, for state: UIControl.State = .normal) -> Self {
        setTitle(text, for: state)
        return self
    }
    
    @discardableResult
    func titleColor(_ color: UIColor, for state: UIControl.State = .normal) -> Self {
        setTitleColor(color, for: state)
        return self
    }
    
    @discardableResult
    func background(_ color: UIColor) -> Self {
        backgroundColor = color
        return self
    }
    
    @discardableResult
    func font(_ font: UIFont) -> Self {
        titleLabel?.font = font
        return self
    }
    
    @discardableResult
    func fontSize(_ size: CGFloat, weight: UIFont.Weight = .regular) -> Self {
        titleLabel?.font = .systemFont(ofSize: size, weight: weight)
        return self
    }
    
    @discardableResult
    func image(_ image: UIImage, for state: UIControl.State = .normal) -> Self {
        setImage(image, for: state)
        return self
    }
    
    @discardableResult
    func bgImage(_ image: UIImage, for state: UIControl.State = .normal) -> Self {
        setBackgroundImage(image, for: state)
        return self
    }
}
