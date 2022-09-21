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
import CoreTelephony

class TranslatorView: UIView {
    
    lazy var kingView = UIView().then{
        $0.backgroundColor = TranslatorModel.backGroundColor
    }
    
    lazy var mainView = UIView().then{
        $0.backgroundColor = .black
    }
    
    lazy var mainStackView = UIStackView().then{
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
        $0.backgroundColor = .clear
    }
    
    // header
    lazy var headerView = UIView().then{
        $0.backgroundColor = .clear
    }
    
    lazy var closeBtn = UIButton().then{
        $0.setTitle("닫기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        $0.backgroundColor = .blue
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
        $0.backgroundColor = .green
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
        $0.backgroundColor = .gray
    }
    
    lazy var sourceTextView = UITextView().then{
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
        $0.backgroundColor = .green
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
        $0.backgroundColor = .gray
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
        $0.setTitle("음성", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .purple
    }
    
    // translateBtn
    lazy var executeTranslatedView = UIView().then{
        $0.backgroundColor = .clear
    }
    
    lazy var executeTranslatedBtn = UIButton().then{
        $0.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        $0.setTitle("번역", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .systemPink
    }
    
    // bottom
    lazy var bottomView = UIView().then{
        $0.backgroundColor = .brown
    }
    
    var disposeBag = DisposeBag()
    var viewModel: TranslatorViewModel!
    
    var timer: Timer!
    
    let audioEngine: AVAudioEngine? = AVAudioEngine()   // audio stream - > 마이크가 오디오를 수신할 떄 업데이트를 제공하는 역할. 순수 소리만을 인식하는 오디오 엔진 객체다.
    var speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()    // 음성 인식을 수행하는 역할. 음성 인식에 실패하면 nil을 반환할 수 있으므로 옵셔널로 만드는 것이 적절하다.
    var request : SFSpeechAudioBufferRecognitionRequest?   // 사용자가 실시간으로 말할 때 음성을 할당하고 버퍼링을 제어하는 역할.
    // 만약 오디오가 미리 녹음되어있는 경우일때는 SFSpeechURLRecognitionRequest를 사용
    var recognitionTask: SFSpeechRecognitionTask?       // 음성 인식 작업을 관리, 취소, 중지등 결과를 제공하는 Task 객체
    
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
        
        headerView.addSubview(closeBtn)
        
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

        headerView.snp.makeConstraints{
            $0.height.equalTo(60)
        }

        closeBtn.snp.makeConstraints{
            $0.left.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }

        bottomView.snp.makeConstraints{
            $0.height.equalTo(40)
        }

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
        sourceTextView.delegate = self
        settingLayer()
        input()
        output()
        binding()
    }
    
    private func settingLayer(){
        sourceContrainerView.layer.cornerRadius = 4
        sourceContrainerView.layer.borderColor = UIColor.purple.cgColor
        sourceContrainerView.layer.borderWidth = 2
        
        translateContrainerView.layer.cornerRadius = 4
        translateContrainerView.layer.borderColor = UIColor.purple.cgColor
        translateContrainerView.layer.borderWidth = 2
    }
    
    private func input(){
        let inputs = TranslatorViewModel.Input(textInput: sourceTextView.rx.text.orEmpty.distinctUntilChanged().map{ $0.trimmingCharacters(in: .whitespacesAndNewlines)}, executeTranslate: executeTranslatedBtn.rx.tap.asObservable(), sourceLanguageTap: sourceLanguageView.rx.tapGesture().when(.recognized).map{ _ in}, targetLanguageTap: targetLanguageView.rx.tapGesture().when(.recognized).map{ _ in})

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
                self.viewModel.model.voiceStatus.accept(.off)
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
        
        self.speakVoiceBtn.rx.tap
            .withLatestFrom(self.viewModel.model.voiceStatus)
            .filter{ $0 == .off}
            .map{ _ in }
            .bind{ [unowned self] in
                log.d("음성입력 모드 on...")
                self.viewModel.model.voiceStatus.accept(.on)
                
                SpeechController.sharedInstance.delegate = self
                
                self.viewModel.model.sourceLanguageCode.value == "언어 감지" ? SpeechController.sharedInstance.prepare() : SpeechController.sharedInstance.prepare(code: self.viewModel.model.sourceLanguageCode.value)

            }
            .disposed(by: disposeBag)
    }
    
    deinit {
        log.d("Translator deinitdeinitdeinitdeinitdeinitdeinitdeinitdeinit")
    }
}
