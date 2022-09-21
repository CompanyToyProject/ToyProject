//
//  SpeechController.swift
//  ToyProject
//
//  Created by yeoboya-211221-05 on 2022/09/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Speech

protocol SpeechToTextProtocol {
    func deliverText(text: String)
}

class SpeechController: NSObject, SFSpeechRecognizerDelegate,  SFSpeechRecognitionTaskDelegate {
    
    static let sharedInstance = SpeechController()
    var delegate: SpeechToTextProtocol!
    var timer: Timer!
    
    let audioEngine: AVAudioEngine? = AVAudioEngine()   // audio stream - > 마이크가 오디오를 수신할 떄 업데이트를 제공하는 역할. 순수 소리만을 인식하는 오디오 엔진 객체다.
    var speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()    // 음성 인식을 수행하는 역할. 음성 인식에 실패하면 nil을 반환할 수 있으므로 옵셔널로 만드는 것이 적절하다.
    var request : SFSpeechAudioBufferRecognitionRequest?   // 사용자가 실시간으로 말할 때 음성을 할당하고 버퍼링을 제어하는 역할.
    // 만약 오디오가 미리 녹음되어있는 경우일때는 SFSpeechURLRecognitionRequest를 사용
    var recognitionTask: SFSpeechRecognitionTask?       // 음성 인식 작업을 관리, 취소, 중지등 결과를 제공하는 Task 객체
    
    override init() {
        super.init()
    }
    
    func checkAuthorizaiton(callback: @escaping () -> Void){
        switch SFSpeechRecognizer.authorizationStatus() {
        case .notDetermined:
            log.d("notDetermined")
            SFSpeechRecognizer.requestAuthorization { (state) in
                if state == .authorized {
                    callback()
                }
            }
        case .authorized:
            log.d("authorized")
            callback()
        case .restricted:
            log.d("restricted")
            return
        case .denied:
            log.d("denied")
            myConfirm(title: "마이크 사용권한 설정이 필요합니다", message: "설정을 변경하시겠습니까?", cancelLabel: "취소", okLabel: "확인", cancelPressed: nil) {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            }
            return
        }
        
    }
    
    func prepare(code: String = "ko") {
            log.d("prepare")
        if self.recognitionTask != nil {
            self.recognitionTask?.cancel()
            self.recognitionTask = nil
        }

        self.speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: code))

        let audioSession = AVAudioSession.sharedInstance()
        
        // 오디오 녹음을 준비 할 AVAuidoSession을 만든다. 여기서 우리는 세션의 범주를 녹음, 측정 모드로 설정하고 활성화합니다. 이러한 속성을 설정하면 예외가 발생할 수 있으므로 try catch 절에 넣어야합니다.
        do {
            try audioSession.setCategory(.record)
            try audioSession.setMode(.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        }
        catch(let error) {
            log.d("audioSession error : \(error)")
        }
        
        self.request = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = self.audioEngine?.inputNode else {
            log.d("audioengine no input node")
            return
        }
        
        guard let myRecognizer = SFSpeechRecognizer() else {
            log.d("recognizer is not supported for the current Locale")
            return
        }
        
        if !myRecognizer.isAvailable {
            log.d("recognizer is not available right now")
        }
        
        guard let request = self.request else {
            return
        }
        request.shouldReportPartialResults = true   // 사용자가 말할 때의 인식 부분적인 결과를 보고하도록 recognitionRequest에 지시

        self.recognitionTask = self.speechRecognizer?.recognitionTask(with: request, delegate: self)

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [unowned self] (buffer, when) in
            self.request?.append(buffer)
        }

        self.audioEngine?.prepare()
        
        do {
            log.d("start")
            try self.audioEngine?.start()
        }
        catch(let error) {
            log.d(error)
        }
        
    }
    
    // 종료시 들어옴
    func speechRecognitionTask(_ task: SFSpeechRecognitionTask, didFinishRecognition recognitionResult: SFSpeechRecognitionResult) {
        log.d("didFinishRecognition")
    }
    
    // 종료시 음성 입력이 존재하냐 안하냐에 따라 true / false 로 나뉨.
    func speechRecognitionTask(_ task: SFSpeechRecognitionTask, didFinishSuccessfully successfully: Bool) {
        log.d("didFinishSuccessfully")
        if self.timer != nil {
            self.timer.invalidate()
            self.timer = nil
        }
        
        if successfully {
            log.d("SpeechController Stop ...")
        }
    }
    
    // 음성 말할 시, 해당 delegate로 들어옴
    func speechRecognitionTask(_ task: SFSpeechRecognitionTask, didHypothesizeTranscription transcription: SFTranscription) {
        let words = transcription.formattedString
        
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true, block: { [unowned self] timer in
            SpeechController.sharedInstance.delegate.deliverText(text: words)
            self.timer.invalidate()
            self.stop()

        })
        
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
        
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
        
        self.audioEngine?.stop()
        self.audioEngine?.inputNode.removeTap(onBus: 0)
        self.request?.endAudio()
        self.recognitionTask = nil
        self.speechRecognizer = nil
    }
    
}
