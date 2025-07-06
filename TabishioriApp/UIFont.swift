//
//  UIFont.swift
//  TabishioriApp
//
//  Created by 田村伊吹 on 2025/07/03.
//

import UIKit

extension UIFont {
    static func setFontZenMaruGothic(size: CGFloat) -> UIFont {
        if let font = UIFont(name: "ZenMaruGothic-Black", size: size) {
            return font
        } else {
            print("フォントが読み込めませんでした")
            return UIFont.systemFont(ofSize: size)
        }
    }
}
