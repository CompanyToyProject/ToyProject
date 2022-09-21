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
        var voiceInputText: PublishSubject<String> = .init()
    }
    
    struct Output {
        var originalText: Driver<String> = BehaviorRelay(value: "").asDriver()
        var sourceLanguage: Driver<String> = BehaviorRelay(value: "").asDriver()
        var targetLanguage: Driver<String> = BehaviorRelay(value: "").asDriver()
        var translatedText: Driver<String> = BehaviorRelay(value: "").asDriver()
    }
    
    var inputMode: Input?
    var output: Output = .init()
    var dispoesBag = DisposeBag()
    var model = TranslatorModel()
    var timer: Timer!
    
    init(input: Input){
        
        self.output.originalText = model.originalText
            .skip(1)
            .withLatestFrom(model.detectedStatus, resultSelector: { [unowned self] (text, status) in
                
                if self.timer != nil {
                    self.timer.invalidate()
                    self.timer = nil
                }

                if text.count != 0 {
                    self.timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true, block: { timer in
                        log.d("detechStatus : \(status) ...")
                        if status == .off {
                            self.detechToTransalte()
                        }
                        else {
                            self.translate()
                        }

                        timer.invalidate()
                    })
                }
//
                return text
            })
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
        
        self.setInputs(input)
    }
    
    func setInputs(_ input: Input) {
        self.inputMode = input
        
        input.textInput
            .bind(to: self.model.originalText)
            .disposed(by: dispoesBag)
        
        input.sourceLanguageTap
            .bind{
                let view = PapagoLanguageView(frame: .zero)
                view.selectModel(.source)
                view.delegate = self
                getTopViewController().view.addSubview(view)
                view.snp.makeConstraints{
                    $0.edges.equalToSuperview()
                }
            }
            .disposed(by: dispoesBag)
        
        input.targetLanguageTap
            .bind{
                let view = PapagoLanguageView(frame: .zero)
                view.selectModel(.target)
                view.delegate = self
                getTopViewController().view.addSubview(view)
                view.snp.makeConstraints{
                    $0.edges.equalToSuperview()
                }
            }
            .disposed(by: dispoesBag)
        
        input.executeTranslate
            .withLatestFrom(self.model.detectedStatus)
            .bind{ [unowned self] (status) in
                
                if self.timer != nil {
                    self.timer.invalidate()
                    self.timer = nil
                }
                
                if status == .off {
                    self.detechToTransalte()
                }
                else{
                    self.translate()
                }
            }
            .disposed(by: dispoesBag)
        
        input.voiceInputText
            .bind(to: self.model.originalText)
            .disposed(by: dispoesBag)


    }
    
}
