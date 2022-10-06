//
//  TranslatorView.swift
//  ToyProject
//
//  Created by yeoboya-211221-05 on 2022/09/19.
//

import Foundation
import UIKit
import RxGesture
import RxSwift
import RxCocoa
import Speech
import SnapKit
import Then
import StoreKit

class TranslatorView: UIView {
    
    lazy var kingView = UIView().then{
        $0.backgroundColor = .white
    }
    
    lazy var mainView = UIView().then{
        $0.backgroundColor = .clear
    }
    
    lazy var mainStackView = UIStackView().then{
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
        $0.backgroundColor = .clear
    }
    
    // header
    lazy var headerView = UIView().then{
        $0.backgroundColor = .black
    }
    
    lazy var closeBtn = UIButton().then{
        $0.setImage(TranslatorModel.close_image, for: .normal)
    }
    
    lazy var currentTechWayLabel = UILabel().then{
        $0.textAlignment = .center
        $0.font = UIFont.boldSystemFont(ofSize: 14)
        $0.textColor = .white
        $0.text = "현재 방식 : "
    }
    
    // body
    lazy var bodyView = UIView().then{
        $0.backgroundColor = .clear
    }
    
    lazy var body_contrainerView = UIView().then{
        $0.backgroundColor = .clear
    }
    
    // sourceView
    lazy var sourceView = UIView().then{
        $0.backgroundColor = .clear
    }
    
    lazy var source_topview = UIView().then{
        $0.backgroundColor = .clear
    }
    
    lazy var sourceLanguageView = UIView().then{
        $0.backgroundColor = TranslatorModel.sourceBgColor
    }

    lazy var sourceLanguageText = UILabel().then{
        $0.font = UIFont.boldSystemFont(ofSize: 14)
        $0.textColor = .black
        $0.textAlignment = .left
        $0.text = "언어 감지"
    }
    
    lazy var sourceLanguageView_image = UIImageView().then{
        $0.contentMode = .scaleToFill
        $0.image = TranslatorModel.arrow_down_image
    }
    
    // sourceView - textView
    lazy var source_mediaView = UIView().then{
        $0.backgroundColor = .clear
    }
    
    lazy var sourceContrainerView = UIView().then{
        $0.backgroundColor = .clear
    }
    
    lazy var sourceTextView = UITextView().then{
        $0.textColor = .black
        $0.backgroundColor = .clear
    }

    // translateView
    lazy var translateView = UIView().then{
        $0.backgroundColor = .clear
    }
    
    lazy var target_topView = UIView().then{
        $0.backgroundColor = .clear
    }
    
    lazy var targetLanguageView = UIView().then{
        $0.backgroundColor = TranslatorModel.sourceBgColor
    }
    
    lazy var targetLanguageText = UILabel().then{
        $0.font = UIFont.boldSystemFont(ofSize: 14)
        $0.textColor = .black
        $0.textAlignment = .left
        $0.text = "설정해주세요"
    }
    
    lazy var targetLanguageView_image = UIImageView().then{
        $0.contentMode = .scaleToFill
        $0.image = TranslatorModel.arrow_down_image
    }
    
    // translateView - textView
    lazy var translate_mediaView = UIView().then{
        $0.backgroundColor = .clear
    }
    
    lazy var translateContrainerView = UIView().then{
        $0.backgroundColor = .white
    }
    
    lazy var translatedTextLabel = UILabel().then{
        $0.textColor = .black
        $0.font = UIFont.boldSystemFont(ofSize: 14)
        $0.textAlignment = .left
        $0.lineBreakMode = .byCharWrapping
        $0.numberOfLines = 0
    }
    
    // voiceBtn
    lazy var speakVoiceBtn = UIButton().then{
        $0.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        $0.setTitle("음성 OFF", for: .normal)
        $0.setTitleColor(TranslatorModel.voiceTextColor, for: .normal)
        $0.backgroundColor = TranslatorModel.voiceBgColor
    }
    
    // translateBtn
    lazy var executeTranslatedView = UIView().then{
        $0.backgroundColor = .clear
    }
    
    lazy var executeTranslatedBtn = UIButton().then{
        $0.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        $0.setTitle("번역", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = TranslatorModel.executeTranslateBtnColor
    }
    
    // bottom
    lazy var bottomView = UIView().then{
        $0.backgroundColor = .clear
    }
    
    lazy var bottomStackView = UIStackView().then{
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .fill
        $0.backgroundColor = .clear
        $0.spacing = 10
    }
    
    lazy var papagoBtn = UIButton().then{
        $0.setTitle("파파고", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .white
    }
    
    lazy var googleBtn = UIButton().then{
        $0.setTitle("구글", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .white
    }
    
    var disposeBag = DisposeBag()
    var viewModel: TranslatorViewModel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        setConstraints()
        firstSetting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView(){
        addSubview(kingView)
        
        kingView.addSubview(mainView)

        mainView.addSubview(mainStackView)

        [headerView, bodyView, bottomView].forEach{
            mainStackView.addArrangedSubview($0)
        }
        
        [closeBtn, currentTechWayLabel].forEach{
            headerView.addSubview($0)
        }
        
        bodyView.addSubview(body_contrainerView)

        [sourceView, executeTranslatedView, translateView].forEach{
            body_contrainerView.addSubview($0)
        }
        
        [source_topview, source_mediaView].forEach{
            sourceView.addSubview($0)
        }
        
        [sourceLanguageView, speakVoiceBtn].forEach{
            source_topview.addSubview($0)
        }
        
        [sourceLanguageText, sourceLanguageView_image].forEach{
            sourceLanguageView.addSubview($0)
        }
        
        source_mediaView.addSubview(sourceContrainerView)

        sourceContrainerView.addSubview(sourceTextView)
    
        executeTranslatedView.addSubview(executeTranslatedBtn)
        
        [target_topView, translate_mediaView].forEach{
            translateView.addSubview($0)
        }
        
        target_topView.addSubview(targetLanguageView)
        
        [targetLanguageText, targetLanguageView_image].forEach{
            targetLanguageView.addSubview($0)
        }
        
        translate_mediaView.addSubview(translateContrainerView)
        
        translateContrainerView.addSubview(translatedTextLabel)
        
        bottomView.addSubview(bottomStackView)
        
        [papagoBtn, googleBtn].forEach{
            bottomStackView.addArrangedSubview($0)
        }
    }
    
    private func setConstraints(){
        kingView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        mainView.snp.makeConstraints{
            $0.edges.equalTo(kingView.safeAreaLayoutGuide)
        }

        mainStackView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }

        // header
        headerView.snp.makeConstraints{
            $0.height.equalTo(60)
        }
        
        currentTechWayLabel.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }

        closeBtn.snp.makeConstraints{
            $0.left.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
        
        // bottom
        bottomView.snp.makeConstraints{
            $0.height.equalTo(40)
        }
        
        bottomStackView.snp.makeConstraints{
            $0.left.right.equalToSuperview().inset(10)
            $0.top.bottom.equalToSuperview()
        }
        
        // body
        body_contrainerView.snp.makeConstraints{
            $0.left.right.equalToSuperview().inset(10)
            $0.top.bottom.equalToSuperview()
        }
        
        sourceView.snp.makeConstraints{
            $0.left.top.right.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.45)
        }
        
        source_topview.snp.makeConstraints{
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview().inset(5)
            $0.height.equalTo(40)
        }
        
        sourceLanguageView.snp.makeConstraints{
            $0.left.top.bottom.equalToSuperview()
            $0.centerY.equalToSuperview()
        }

        sourceLanguageText.snp.makeConstraints{
            $0.left.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
            $0.right.greaterThanOrEqualTo(sourceLanguageView_image.snp.left).offset(-50)
        }

        sourceLanguageView_image.snp.makeConstraints{
            $0.right.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
        
        speakVoiceBtn.snp.makeConstraints{
            $0.right.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        source_mediaView.snp.makeConstraints{
            $0.top.equalTo(source_topview.snp.bottom).offset(5)
            $0.left.right.bottom.equalToSuperview()
        }

        sourceContrainerView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }

        sourceTextView.snp.makeConstraints{
            $0.edges.equalToSuperview().inset(10)
        }

        executeTranslatedView.snp.makeConstraints{
            $0.left.right.equalToSuperview()
            $0.top.equalTo(sourceView.snp.bottom)
            $0.height.equalToSuperview().multipliedBy(0.1)
        }
        
        executeTranslatedBtn.snp.makeConstraints{
            $0.center.equalToSuperview()
        }
        
        translateView.snp.makeConstraints{
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(executeTranslatedView.snp.bottom)
        }
        
        target_topView.snp.makeConstraints{
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        targetLanguageView.snp.makeConstraints{
            $0.left.top.bottom.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        targetLanguageText.snp.makeConstraints{
            $0.left.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
            $0.right.greaterThanOrEqualTo(targetLanguageView_image.snp.left).offset(-50)
        }
        
        targetLanguageView_image.snp.makeConstraints{
            $0.right.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
        
        translate_mediaView.snp.makeConstraints{
            $0.top.equalTo(target_topView.snp.bottom).offset(5)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().inset(5)
        }
        
        translateContrainerView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        translatedTextLabel.snp.makeConstraints{
            $0.left.top.right.equalToSuperview().inset(10)
            $0.bottom.lessThanOrEqualTo(translateContrainerView.snp.bottom).inset(10)
        }

    }
    
    
    private func firstSetting(){
        getNavigationController().isNavigationBarHidden = true
        settingLayer()
        input()
        output()
        binding()
    }
    
    private func settingLayer(){
        sourceLanguageView.layer.cornerRadius = 4
        targetLanguageView.layer.cornerRadius = 4
        speakVoiceBtn.layer.cornerRadius = 4
        
        sourceContrainerView.layer.cornerRadius = 4
        sourceContrainerView.layer.borderColor = TranslatorModel.textviewBorderColor.cgColor
        sourceContrainerView.layer.borderWidth = 2
        
        translateContrainerView.layer.cornerRadius = 4
        translateContrainerView.layer.borderColor = TranslatorModel.textviewBorderColor.cgColor
        translateContrainerView.layer.borderWidth = 2
        
        bottomStackView.clipsToBounds = true
        papagoBtn.layer.cornerRadius = 4
        googleBtn.layer.cornerRadius = 4
    }
    
    private func input(){
        let inputs = TranslatorViewModel.Input(textInput: sourceTextView.rx.text.orEmpty.distinctUntilChanged().map{ $0.trimmingCharacters(in: .whitespacesAndNewlines)}, executeTranslate: executeTranslatedBtn.rx.tap.asObservable(), sourceLanguageTap: sourceLanguageView.rx.tapGesture().when(.recognized).map{ _ in}, targetLanguageTap: targetLanguageView.rx.tapGesture().when(.recognized).map{ _ in}, papagoTap: papagoBtn.rx.tap.asObservable(), googleTap: googleBtn.rx.tap.asObservable(), speakVoiceTap: speakVoiceBtn.rx.tap.asObservable())

        self.viewModel = TranslatorViewModel(input: inputs)
    }
    
    private func output(){
        
        self.viewModel.output.originalText
            .drive(sourceTextView.rx.text)
            .disposed(by: disposeBag)
        
        self.viewModel.output.sourceLanguage
            .drive(sourceLanguageText.rx.text)
            .disposed(by: disposeBag)
        
        self.viewModel.output.targetLanguage
            .drive(targetLanguageText.rx.text)
            .disposed(by: disposeBag)
        
        self.viewModel.output.translatedText
            .drive{ [unowned self] (text) in
                self.translatedTextLabel.text = text
                self.sourceTextView.endEditing(true)
 
                if self.viewModel.model.voiceStatus.value == .on {
                    
                    if self.viewModel.model.currentTechWay.value == .google {
                        AudioStreamManager.shared.stop()
                        self.viewModel.service.stopStreaming()
                    }
                    
                    self.viewModel.model.voiceStatus.accept(.off)
                    self.viewModel.model.voiceText.accept("음성 OFF")
                }

            }
            .disposed(by: disposeBag)
        
        self.viewModel.output.voiceText
            .drive(speakVoiceBtn.rx.title())
            .disposed(by: disposeBag)
        
        self.viewModel.output.isPapago
            .drive{ [unowned self] (status) in
                if status {
                    self.papagoBtn.backgroundColor = TranslatorModel.currentTechColor
                    self.papagoBtn.setTitleColor(.white, for: .normal)
                    self.papagoBtn.layer.borderWidth = 0
                    self.papagoBtn.layer.borderColor = nil
                }
                else {
                    self.papagoBtn.backgroundColor = .white
                    self.papagoBtn.setTitleColor(TranslatorModel.currentTechColor, for: .normal)
                    self.papagoBtn.layer.borderColor = TranslatorModel.currentTechColor.cgColor
                    self.papagoBtn.layer.borderWidth = 1
                }
            }
            .disposed(by: disposeBag)
        
        self.viewModel.output.isGoogle
            .drive{ [unowned self] (status) in
                if status {
                    self.googleBtn.backgroundColor = TranslatorModel.currentTechColor
                    self.googleBtn.setTitleColor(.white, for: .normal)
                    self.googleBtn.layer.borderWidth = 0
                    self.googleBtn.layer.borderColor = nil
                }
                else {
                    self.googleBtn.backgroundColor = .white
                    self.googleBtn.setTitleColor(TranslatorModel.currentTechColor, for: .normal)
                    self.googleBtn.layer.borderColor = TranslatorModel.currentTechColor.cgColor
                    self.googleBtn.layer.borderWidth = 1
                }
            }
            .disposed(by: disposeBag)
        
    }
    
    private func binding(){
        closeBtn.rx.tap
            .bind{ [unowned self] in
                SpeechController.sharedInstance.stop()
                self.removeFromSuperview()
            }
            .disposed(by: disposeBag)
        
        mainView.rx.tapGesture()
            .when(.recognized)
            .bind{ [unowned self] _ in
                self.sourceTextView.endEditing(true)
            }
            .disposed(by: disposeBag)

    }
    
    deinit {
        log.d("Translator deinitdeinitdeinitdeinitdeinitdeinitdeinitdeinit")
    }
}
