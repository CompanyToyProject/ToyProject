//
//  TranslatorViewModel++.swift
//  ToyProject
//
//  Created by yeoboya-211221-05 on 2022/09/20.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON

extension TranslatorViewModel {
    
    func localizedString(code: String) -> String{
        
        var languageCode = code

        if languageCode == "zh-CN" {
            languageCode = "zh-Hans"
        }
        
        if languageCode == "zh-TW" {
            languageCode = "zh-Hant"
        }
        
        return languageCode.localizeIdentifier()
        
    }

    func detechToTransalte(){
        let papago = Papago()
        papago.detechLanguage(text: self.model.originalText.value) { (languageCode) in
            if self.model.sourceLanguageCode.value == "언어 감지" {
                self.model.sourceLanguageCode.accept(languageCode)
                self.model.sourceLanguageText.accept(self.localizedString(code: languageCode))
            }
            
            papago.translatedLanguage(text: self.model.originalText.value, sourceLanguage: self.model.sourceLanguageCode.value, targetLanguage: self.model.targetLanguageCode.value) { (translatedText) in
                self.model.translatedText.accept(translatedText)
            }
        }
        
    }
    
    func translate(){
        let papago = Papago()
        
        papago.translatedLanguage(text: self.model.originalText.value, sourceLanguage: self.model.sourceLanguageCode.value, targetLanguage: self.model.targetLanguageCode.value) { (translatedText) in
            self.model.translatedText.accept(translatedText)
        }
    }
    
}
