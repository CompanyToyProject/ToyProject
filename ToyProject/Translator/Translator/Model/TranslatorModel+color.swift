//
//  TranslatorModel+color.swift
//  ToyProject
//
//  Created by yeoboya-211221-05 on 2022/09/19.
//

import Foundation
import UIKit

extension TranslatorModel {
    static let headerColor = UIColor(r: 217, g: 220, b: 228)
    static let sourceBgColor = UIColor(r: 236, g: 236, b: 242, a: 1.0)
    static let targetBgColor = UIColor(r: 236, g: 236, b: 242, a: 1.0)
    static let currentTechColor = UIColor(r: 17, g: 133, b: 223, a: 1.0)
    static let executeTranslateBtnColor = UIColor(r: 88, g: 93, b: 239, a: 1.0)
    static let voiceBgColor = UIColor(r: 20, g: 27, b: 46, a: 1.0)
    static let voiceTextColor = UIColor(r: 220, g: 155, b: 99)
    static let textviewBorderColor = UIColor(r: 112, g: 112, b: 112, a: 1.0)
}

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
}
