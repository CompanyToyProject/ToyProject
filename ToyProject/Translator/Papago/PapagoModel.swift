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
    
    static let supportedLanguagesURL = "https://translation.googleapis.com/v3/projects/hidden-pad-361207/locations/global/supportedLanguages?key=AIzaSyDvY8BSf0-Zz7rkfUmP0fNYlwi1GrLlb2M"
    
    
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
    
    let getAPILanguageCode = [
        "언어 감지"
    ]
    
}
