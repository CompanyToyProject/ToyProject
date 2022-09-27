//
//  TranslatorViewModel++++.swift
//  ToyProject
//
//  Created by yeoboya-211221-05 on 2022/09/26.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension TranslatorViewModel: SpeechToTextProtocol, StreamDelegate {
    
    func deliverText(text: String) {
        log.d("voice deliverText: \(text) ...")
        let originText = self.model.originalText.value
        self.model.originalText.accept(originText + text)
    }
    
    func processAudio(_ data: Data) {
        log.d("hi")
    }
    
    
}
