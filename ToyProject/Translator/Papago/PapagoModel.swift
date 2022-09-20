//
//  PapagoModel.swift
//  ToyProject
//
//  Created by yeoboya-211221-05 on 2022/09/20.
//

import Foundation
import UIKit

struct PapagoModel {
    
    enum Code {
        case source
        case target
    }
    
    let sourceLanuageCode = [
        "언어 감지", "ko", "en", "ja", "zh-CN", "zh-TW", "vi", "id", "th", "de", "ru", "es", "it", "fr"
    ]
    
    let sourceAppleCode = [
        "언어 감지", "ko", "en", "ja", "zh-Hans", "zh-Hant", "vi", "id", "th", "de", "ru", "es", "it", "fr"
    ]
    
    let targetLanugaeCode = [
        "ko", "en", "ja", "zh-CN", "zh-TW", "vi", "id", "th", "de", "ru", "es", "it", "fr"
    ]
    
    let targetAppleCode = [
        "ko", "en", "ja", "zh-Hans", "zh-Hant", "vi", "id", "th", "de", "ru", "es", "it", "fr"
    ]
    
}
