//
//  TranslatorViewModel.swift
//  ToyProject
//
//  Created by yeoboya-211221-05 on 2022/09/19.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit

class TranslatorViewModel {
    
    struct Input {
        var textInput: Observable<String>
        var executeTranslate: Observable<Void>
        var sourceLanguageTap: Observable<Void>
        var targetLanguageTap: Observable<Void>
        var papagoTap: Observable<Void>
        var googleTap: Observable<Void>
        var voiceInputText: PublishSubject<String> = .init()
    }
    
    struct Output {
        var originalText: Driver<String> = BehaviorRelay(value: "").asDriver()
        var sourceLanguage: Driver<String> = BehaviorRelay(value: "").asDriver()
        var targetLanguage: Driver<String> = BehaviorRelay(value: "").asDriver()
        var translatedText: Driver<String> = BehaviorRelay(value: "").asDriver()
        var voiceText: Driver<String> = BehaviorRelay(value: "음성 OFF").asDriver()
    }
    
    var inputMode: Input?
    var output: Output = .init()
    var dispoesBag = DisposeBag()
    var model = TranslatorModel()
    var timer: Timer!
    
    init(input: Input){
        
//        self.output.originalText = model.originalText
//            .skip(1)
//            .withLatestFrom(model.detectedStatus, resultSelector: { [unowned self] (text, status) in
//
//                if self.timer != nil {
//                    self.timer.invalidate()
//                    self.timer = nil
//                }
//
//                if text.count != 0 {
//                    self.timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true, block: { timer in
//                        log.d("detechStatus : \(status) ...")
//                        if status == .off {
//                            self.detechToTransalte()
//                        }
//                        else {
//                            self.translate()
//                        }
//
//                        timer.invalidate()
//                    })
//                }
//
//                return text
//            })
//            .map{ return $0}
//            .distinctUntilChanged()
//            .asDriver(onErrorRecover: { _ in .empty()})
        
        self.output.originalText = model.originalText
            .skip(1)
            .withLatestFrom(model.detectedStatus){ ($0, $1)}
            .withLatestFrom(model.currentTechWay){ ($0.0, $0.1, $1)}
            .map{ [unowned self] (text, detechStatus, techWay) in
                
                if self.timer != nil {
                    self.timer.invalidate()
                    self.timer = nil
                }
                
                if text.count != 0 {
                    self.timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true, block: { timer in
                        if techWay == .papago {
                            if detechStatus == .off {
                                self.detechToTransalte()
                            }
                            else {
                                self.translate()
                            }
                        }
                        else {
                            if detechStatus == .off {
                                
                            }
                            else {
                                
                            }
                        }
                        timer.invalidate()
                    })
                }
                
                return text
            }
            .map{ return $0}
            .distinctUntilChanged()
            .asDriver(onErrorRecover: { _ in .empty()})
        
        // sourceLanguageText
        self.output.sourceLanguage = model.sourceLanguageText
            .map{ return $0}
            .distinctUntilChanged()
            .asDriver(onErrorRecover: { _ in .empty()})
        
        // translatedText
        self.output.translatedText = model.translatedText
            .map{ return $0 }
            .distinctUntilChanged()
            .asDriver(onErrorRecover: { _ in .empty()})
        
        // targetLanguageText
        self.output.targetLanguage = model.targetLanguageCode
            .map{ [unowned self] in return self.localizedString(code: $0) }
            .distinctUntilChanged()
            .asDriver(onErrorRecover: { _ in .empty()})
        
        self.output.voiceText = model.voiceText
            .map{ return $0 }
            .distinctUntilChanged()
            .asDriver(onErrorRecover: { _ in .empty()})
        
        self.setInputs(input)
    }
    
    func setInputs(_ input: Input) {
        self.inputMode = input
        
        input.textInput
            .bind(to: self.model.originalText)
            .disposed(by: dispoesBag)
        
        input.sourceLanguageTap
            .withLatestFrom(self.model.currentTechWay)
            .bind{ [unowned self] (techWay) in
                if techWay == .papago {
                    let view = PapagoLanguageView(frame: .zero)
                    view.selectModel(.source)
                    view.delegate = self
                    getTopViewController().view.addSubview(view)
                    view.snp.makeConstraints{
                        $0.edges.equalToSuperview()
                    }
                }
                else {
                    self.googleSupportedLanguage()
                }
            }
            .disposed(by: dispoesBag)
        
        input.targetLanguageTap
            .withLatestFrom(self.model.currentTechWay)
            .bind{ (techWay) in
                if techWay == .papago {
                    let view = PapagoLanguageView(frame: .zero)
                    view.selectModel(.target)
                    view.delegate = self
                    getTopViewController().view.addSubview(view)
                    view.snp.makeConstraints{
                        $0.edges.equalToSuperview()
                    }
                }
                else {
                    
                }
            }
            .disposed(by: dispoesBag)
        
        input.executeTranslate
            .withLatestFrom(self.model.detectedStatus)
            .withLatestFrom(self.model.currentTechWay){($0, $1)}
            .bind{ [unowned self] (detechStatus, techWay) in
                log.d("11")
                if self.timer != nil {
                    self.timer.invalidate()
                    self.timer = nil
                }

                if techWay == .papago {
                    if detechStatus == .off {
                        self.detechToTransalte()
                    }
                    else{
                        self.translate()
                    }
                }
                else {
                    if detechStatus == .off {
                        
                    }
                }
            }
            .disposed(by: dispoesBag)
        
        input.voiceInputText
            .bind(to: self.model.originalText)
            .disposed(by: dispoesBag)

        input.papagoTap
            .bind{ [unowned self] in
                log.d("papago Technology on...")
                self.model.currentTechWay.accept(.papago)
            }
            .disposed(by: dispoesBag)
        
        input.googleTap
            .bind{ [unowned self] in
                log.d("google Technology on...")
                self.model.currentTechWay.accept(.google)
            }
            .disposed(by: dispoesBag)

    }
    
    deinit {
        log.d("TranslatorViewModel deinitdeinitdeinitdeinitdeinitdeinitdeinitdeinit")
    }
    
}
