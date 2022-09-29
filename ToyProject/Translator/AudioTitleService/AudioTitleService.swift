//
//  AudioTitleService.swift
//  ToyProject
//
//  Created by yeoboya-211221-05 on 2022/09/28.
//

import Foundation
import UIKit
import Speech

protocol AudioTitleServiceProtocol: AnyObject {
    func audioToText(text: String)
}

class AudioTitleService: NSObject, SFSpeechRecognizerDelegate,  SFSpeechRecognitionTaskDelegate {
    
    static let sharedInstance = AudioTitleService()
    
    let audioEngine: AVAudioEngine? = AVAudioEngine()
    var speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    var request: SFSpeechURLRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    
    weak var delegate: AudioTitleServiceProtocol?
    
    override init() {
        super.init()
    }
    
    func prepare(){
        if self.recognitionTask != nil {
            self.recognitionTask?.cancel()
            self.recognitionTask = nil
        }

        self.speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: Locale.preferredLanguages.first!))

        self.request = SFSpeechURLRecognitionRequest(url: URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true).appendingPathComponent("recording.m4a"))
        
        guard let request = request else {
            return
        }

        LoadingIndicator.show()

        self.recognitionTask = self.speechRecognizer?.recognitionTask(with: request, delegate: self)

    }
    
    
    // 종료시 들어옴
    func speechRecognitionTask(_ task: SFSpeechRecognitionTask, didFinishRecognition recognitionResult: SFSpeechRecognitionResult) {
        log.d("didFinishRecognition")
        let result = recognitionResult.bestTranscription.formattedString
        AudioTitleService.sharedInstance.delegate?.audioToText(text: result)
    }
    
    // 종료시 음성 입력이 존재하냐 안하냐에 따라 true / false 로 나뉨.
    func speechRecognitionTask(_ task: SFSpeechRecognitionTask, didFinishSuccessfully successfully: Bool) {
        log.d("didFinishSuccessfully")
        if successfully {
            LoadingIndicator.hide()
        }
    }
    
    // 음성 말할 시, 해당 delegate로 들어옴
    func speechRecognitionTask(_ task: SFSpeechRecognitionTask, didHypothesizeTranscription transcription: SFTranscription) {
        let words = transcription.formattedString
        log.d(words)
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        log.d("availabilityDidChange")
    }
    
    func speechRecognitionDidDetectSpeech(_ task: SFSpeechRecognitionTask) {
        log.d("speechRecognitionDidDetectSpeech")
    }
    
    func speechRecognitionTaskWasCancelled(_ task: SFSpeechRecognitionTask) {
        log.d("speechRecognitionTaskWasCancelled")
    }
    
    func speechRecognitionTaskFinishedReadingAudio(_ task: SFSpeechRecognitionTask) {
        log.d("speechRecognitionTaskFinishedReadingAudio")
    }
    
    func stop(){
        if self.recognitionTask != nil {
            self.recognitionTask?.cancel()
            self.recognitionTask = nil
            LoadingIndicator.hide()
        }
        
    }
    

    
}
