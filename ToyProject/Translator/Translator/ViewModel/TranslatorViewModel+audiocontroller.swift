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
    
    // papago
    func deliverText(text: String) {
        log.d("voice deliverText: \(text) ...")
        let originText = self.model.originalText.value
        self.model.originalText.accept(originText + text)
    }
    
    // google
    func processAudio(_ data: Data) {
        self.audioData.append(data)
        
        let chunkSize = Int(0.1 * GoogleCloudModel.sampleRate * 2)
        
        if self.audioData.count > chunkSize {
            if self.model.sourceLanguageText.value == "언어 감지" {
                self.service.getStreamResponse(self.audioData, completion: { [unowned self] (response) in
                    guard let results = response.results.first else {
                        return
                    }
                    
                    guard let text = results.alternatives.first?.transcript else {
                        return
                    }

                    self.model.originalText.accept(text)
                })
            }
            else {
                self.service.getStreamResponse(self.audioData, self.model.sourceLanguageCode.value, completion: { [unowned self] (response) in
                    guard let results = response.results.first else {
                        return
                    }
                    
                    guard let text = results.alternatives.first?.transcript else {
                        return
                    }
                    
                    self.model.originalText.accept(text)
                })
            }
            self.audioData = NSMutableData()
        }
    }
    
    
}
