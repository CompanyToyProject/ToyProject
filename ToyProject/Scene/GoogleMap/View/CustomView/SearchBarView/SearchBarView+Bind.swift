//
//  SearchBarView+Bind.swift
//  ToyProject
//
//  Created by yeoboya on 2022/09/16.
//

import Foundation
import RxSwift
import RxCocoa
import AVFAudio
import Speech

extension SearchBarView {
    func bind() {
        tableViewController?.tableViewHeight
            .distinctUntilChanged()
            .bind(onNext: { [weak self] height in
                self?.tableView.snp.updateConstraints { make in
                    make.height.equalTo(height)
                    make.bottom.equalToSuperview().inset(10)
                }
            })
            .disposed(by: disposeBag)
        
        tableViewController?.selectItem
            .bind(onNext: { [weak self] localCoordinate in
                guard let self = self else { return }
                if let _  = localCoordinate.level1,
                   localCoordinate.level1!.contains("검색된 지역이 없습니다.") {
                    self.textView.text = ""
                } else {
                    self.selectItem.onNext(localCoordinate)
                    self.textView.text = localCoordinate.localFullString
                }
                self.endEditing()
            })
            .disposed(by: disposeBag)
        
        searchBtn.rx.tap
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.tableViewController?.updateText.onNext((self.textView.text, self.textView.hasText))
                self.endEditing()
            })
            .disposed(by: disposeBag)
        
        micBtn.rx.tap
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.endEditing()
                self.tableViewZeroHeight()
                if self.audioEngine.isRunning { // 현재 음성인식 수행중이라면
                    self.stopRecording()
                }
                else {
                    self.STTText
                        .do(onNext: { text in
                            print("인식된 텍스트: \(text)")
                        })
                            .timeout(.seconds(3), scheduler: MainScheduler.instance)
                            .subscribe { text in
                                log.d("입력됨: \(text)")
                            } onError: { error in
                                if case .timeout = error as? RxError {
                                    print("TimeOutError - 검색 됩니다.")
                                    self.stopRecording()
                                }
                            } onDisposed: {
                                print("onDisposeddddd")
                            }
                            .disposed(by: self.disposeBag)
                    self.startRecording()
                    self.micBtn.setImage(UIImage(systemName: "mic"), for: .normal)
                }
            })
            .disposed(by: disposeBag)

    }
    
    func stopRecording() {
        self.audioEngine.stop()  // 오디오 입력 중단
        self.recognitionRequest?.endAudio() // 음성인식 중단
        self.micBtn.setImage(UIImage(systemName: "mic.fill"), for: .normal)
        
        if self.textView.hasText {
            self.tableViewController?.updateText.onNext((self.textView.text, true))
        } else {
            self.tableViewController?.updateText.onNext(("", true))
        }
    }
    
    func startRecording() {
        if recognitionTask != nil {    // 인식 작업이 실행중인지? 실행중일 경우 작업과 인식 취소
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        else {
            // 오디오 녹음을 준비할 AVAudioSession 만들기
            let audioSession = AVAudioSession.sharedInstance()
            
            do {
                try audioSession.setCategory(.record)
                try audioSession.setMode(.measurement)
                try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            } catch {
                print("audioSession properties weren't set because of an error.")
                print("[ErrorDescription]: \(error.localizedDescription)")
            }
            
            recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            
            let inputNode = audioEngine.inputNode
            
            guard let recognitionRequest = recognitionRequest else {
                fatalError("Unable to create an SFSpeechAudioBuffer RecognitionRequest object")
            }
            
            recognitionRequest.shouldReportPartialResults = true
            
            recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { result, error in
                var isFinal = false
                if result != nil {
                    guard let resultText = result?.bestTranscription.formattedString else { return }
                    self.textView.text = resultText
                    self.STTText.onNext(resultText)
                    isFinal = (result?.isFinal)!
                }
                
                if error != nil || isFinal {
                    self.audioEngine.stop()
                    
                    inputNode.removeTap(onBus: 0)
                    
                    self.recognitionRequest = nil
                    self.recognitionTask = nil
                }
            })
            
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, when in
                self.recognitionRequest?.append(buffer)
            }
            
            audioEngine.prepare()
            
            do {
                try audioEngine.start()
            } catch {
                print("audioEngine couldn't start because of an error.")
            }
            
            self.textView.text = "음성인식중..."
        }
    }
}
