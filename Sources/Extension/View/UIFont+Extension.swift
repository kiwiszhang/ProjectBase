//
//  UIFont+Extension.swift
//  MobileProject
//
//  Created by 笔尚文化 on 2025/4/17.
//

import Foundation

//enum HelveticaNeueWeight: String {
//    case ultraLight = "UltraLight"
//    case light = "Light"
//    case regular = ""          // HelveticaNeue 无后缀
//    case medium = "Medium"
//    case bold = "Bold"
//    case condensedBold = "CondensedBold"
//}

enum InterWeight {
    case light, regular, medium, bold
}

enum ArchivoBlackWeight {
    case  regular
}

extension UIFont {
    static func inter(size: CGFloat, weight: InterWeight = .regular) -> UIFont {
        
//        let fontName = "HelveticaNeue" + (weight.rawValue.isEmpty ? "" : "-\(weight.rawValue)")
//        if let font = UIFont(name: fontName, size: size) {
//            return font
//        }
        
        // 对应 SwiftGen fonts.yml 里生成的
        let fontConvertible: FontConvertible
        switch weight {
        case .light:
            fontConvertible = FontFamily.Inter.lightBETA
        case .regular:
            fontConvertible = FontFamily.Inter.regular
        case .medium:
            fontConvertible = FontFamily.Inter.medium
        case .bold:
            fontConvertible = FontFamily.Inter.bold
        }
        
        let customFont = fontConvertible.font(size: size)
        return customFont
    }
    
    static func archivoBlack(size: CGFloat, weight: ArchivoBlackWeight = .regular) -> UIFont {
        // 对应 SwiftGen fonts.yml 里生成的
        let fontConvertible: FontConvertible
        switch weight {
        case .regular:
            fontConvertible = FontFamily.ArchivoBlack.regular
        }
        
        let customFont = fontConvertible.font(size: size)
        return customFont
    }
}
