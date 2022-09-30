//
//  TranslatorViewModel+++.swift
//  ToyProject
//
//  Created by yeoboya-211221-05 on 2022/09/20.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension TranslatorViewModel: SelectedLanguageCodeProtocol {
    
    func isSelectedLanguageCode(papagoCode: String, appleCode: String, code: PapagoModel.Code) {
        
        if code == .source {
            self.model.sourceLanguageCode.accept(papagoCode)
            self.model.sourceLanguageText.accept(appleCode.localizeIdentifier())
            
            if self.model.sourceLanguageCode.value == "언어 감지" {
                self.model.detectedStatus.accept(.off)
            }
            
        }
        else {
            self.model.targetLanguageCode.accept(papagoCode)
            self.model.targetLanguageText.accept(appleCode.localizeIdentifier())
        }
        
    }
    
    
}
