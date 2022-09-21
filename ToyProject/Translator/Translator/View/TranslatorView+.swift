//
//  TranslatorView+.swift
//  ToyProject
//
//  Created by yeoboya-211221-05 on 2022/09/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Speech

extension TranslatorView: SpeechToTextProtocol, UITextViewDelegate, SFSpeechRecognizerDelegate, SFSpeechRecognitionTaskDelegate {
    
    func deliverText(text: String) {
        log.d("voice deliverText : \(text) ...")
        self.viewModel?.inputMode?.voiceInputText.onNext(self.viewModel.model.originalText.value + text)
    }

}
