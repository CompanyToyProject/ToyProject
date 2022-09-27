//
//  TranslatorViewModel+etc.swift
//  ToyProject
//
//  Created by yeoboya-211221-05 on 2022/09/26.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension TranslatorViewModel {
    
    func voiceStatus(_ status: TranslatorModel.Status ){
        if self.model.voiceStatus.value == .on {
            if self.model.currentTechWay.value == .papago {
                SpeechController.sharedInstance.stop()
            }
            else {
                AudioStreamManager.shared.stop()
            }
        }
        
        if status == .off {
            self.model.voiceText.accept("음성 OFF")
        }
        else {
            self.model.voiceText.accept("음성 ON")
        }

    }
    
    func speakVoiceTap(_ status: TranslatorModel.Status, _ techWay: TranslatorModel.Tech) {
        
        if status == .off {
            self.model.voiceStatus.accept(.on)
            self.model.voiceText.accept("음성 ON")
        }
        else {
            self.model.voiceStatus.accept(.off)
            self.model.voiceText.accept("음성 OFF")
        }
        
        if techWay == .papago {
            if status == .off {
                SpeechController.sharedInstance.delegate = self
                
                self.model.sourceLanguageCode.value == "언어 감지" ? SpeechController.sharedInstance.prepare() : SpeechController.sharedInstance.prepare(code: self.model.sourceLanguageCode.value)
            }
            else {
                SpeechController.sharedInstance.stop()
            }
        }
        else {
            if status == .off {
                AudioStreamManager.shared.delegate = self
                do {
                    try AudioStreamManager.shared.prepare()
                    AudioStreamManager.shared.start()
                }
                catch {
                    log.d(error)
                }
            }
            else {
                AudioStreamManager.shared.stop()
            }
        }
    
        
    }
}
