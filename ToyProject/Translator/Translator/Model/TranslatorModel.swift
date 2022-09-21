//
//  TranslatorModel.swift
//  ToyProject
//
//  Created by yeoboya-211221-05 on 2022/09/19.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class TranslatorModel {
    
    enum Status {
        case on
        case off
    }
    
    var detectedStatus: BehaviorRelay<Status> = BehaviorRelay(value: .off)  // 언어감지 status
    var originalText: BehaviorRelay<String> = BehaviorRelay(value: "")      // 번역 전 테스트
    var translatedText: BehaviorRelay<String> = BehaviorRelay(value: "")    // 번역 후 테스트
    
    var sourceLanguageText: BehaviorRelay<String> = BehaviorRelay(value: "언어 감지")    // sourceLanuage 설정 언어 ex) 기본 언어 감지, 그 이후 한국어, 영어..
    var targetLanguageText: BehaviorRelay<String> = BehaviorRelay(value: "")          // 해당 언어로 번역
    
    var sourceLanguageCode: BehaviorRelay<String> = BehaviorRelay(value: "언어 감지") // source languageCode ex) ko , en , jp ...
    var targetLanguageCode: BehaviorRelay<String> = BehaviorRelay(value: "en")
    
    var voiceStatus: BehaviorRelay<Status> = BehaviorRelay(value: .off)     // 음성 status
//    var voiceText: BehaviorRelay<String> = BehaviorRelay(value: "")         // 음성 Text
}
