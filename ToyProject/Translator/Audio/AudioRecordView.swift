//
//  AudioRecordView.swift
//  ToyProject
//
//  Created by yeoboya-211221-05 on 2022/09/28.
//

import Foundation
import AVFoundation
import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import Speech

class AudioRecordView: UIView, AVAudioRecorderDelegate, AVAudioPlayerDelegate, AudioTitleServiceProtocol {

    lazy var kingView = UIView().then{
        $0.backgroundColor = .white
    }
    
    lazy var mainView = UIView().then{
        $0.backgroundColor = .clear
    }
    
    lazy var mainStackView = UIStackView().then{
        $0.distribution = .fill
        $0.alignment = .fill
        $0.axis = .vertical
        $0.backgroundColor = .clear
    }
    
    // header
    lazy var headerView = UIView().then{
        $0.backgroundColor = .clear
    }
  
    lazy var closeBtn = UIButton().then{
        $0.setTitle("닫기", for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .black
    }
    
    lazy var audioToTextBtn = UIButton().then{
        $0.setTitle("오디오 텍스트 변경", for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .black
    }
    
    // body
    lazy var bodyView = UIView().then{
        $0.backgroundColor = .clear
    }
    
    lazy var audioTitleLabel = UILabel().then{
        $0.textColor = .black
        $0.contentMode = .left
        $0.font = UIFont.boldSystemFont(ofSize: 14)
        $0.numberOfLines = 0
    }
    
    // bottom
    lazy var bottomView = UIView().then{
        $0.backgroundColor = .clear
    }
    
    lazy var bottomBtnStackView = UIStackView().then{
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .fill
        $0.spacing = 5
    }
    
    lazy var recordBtn = UIButton().then{
        $0.setTitle("녹음하기", for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .black
    }
    
    lazy var playAudioBtn = UIButton().then{
        $0.setTitle("오디오듣기", for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .black
    }
    
    var disposeBag = DisposeBag()
    
    let recordingFilePath_m4a = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true).appendingPathComponent("recording.m4a")
    let recordingSettings = [
        AVFormatIDKey: NSNumber(value: Int32(kAudioFormatMPEG4AAC)),
        AVNumberOfChannelsKey: NSNumber(value: 2),
        AVSampleRateKey: NSNumber(value: Int32(16000)),
        AVEncoderAudioQualityKey: NSNumber(value: Int32(AVAudioQuality.max.rawValue))
    ]
    
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    var state: Bool = false
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        setConstraints()
        firstSetting()
        binding()
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
        
        [closeBtn, audioToTextBtn].forEach{
            headerView.addSubview($0)
        }
        
        bodyView.addSubview(audioTitleLabel)
        
        bottomView.addSubview(bottomBtnStackView)
        
        [recordBtn, playAudioBtn].forEach{
            bottomBtnStackView.addArrangedSubview($0)
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
        
        headerView.snp.makeConstraints{
            $0.height.equalTo(50)
        }
        
        closeBtn.snp.makeConstraints{
            $0.left.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview()
        }
        
        audioToTextBtn.snp.makeConstraints {
            $0.right.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview()
        }
        
        audioTitleLabel.snp.makeConstraints{
            $0.left.top.right.equalToSuperview().inset(10)
            $0.bottom.lessThanOrEqualTo(bottomView.snp.top).offset(-10)
        }
        
        bottomView.snp.makeConstraints{
            $0.height.equalTo(50)
        }
        
        bottomBtnStackView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
    private func firstSetting(){
        getNavigationController().isNavigationBarHidden = true
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setMode(AVAudioSession.Mode.default)
            try audioSession.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try audioSession.setActive(true)
        }
        catch let error {
            log.e(error)
        }

        audioSession.requestRecordPermission({_ in})
    }
    
    private func binding(){
        closeBtn.rx.tap
            .bind{ [unowned self] in
                self.removeFromSuperview()
            }
            .disposed(by: disposeBag)
        
        recordBtn.rx.tap
            .bind{ [unowned self] in
                log.d(self.state)
                if !state {
                    self.getRecord()
                }
                else {
                    self.stopRecordingAudio()
                }
            }
            .disposed(by: disposeBag)
        
        playAudioBtn.rx.tap
            .bind{ [unowned self] in
                self.playAudio()
            }
            .disposed(by: disposeBag)
        
        audioToTextBtn.rx.tap
            .bind{ [unowned self] in
                
                AudioTitleService.sharedInstance.delegate = self
                AudioTitleService.sharedInstance.prepare()
                
            }
            .disposed(by: disposeBag)
    }
    
    func getRecord(){
        let audioSession = AVAudioSession.sharedInstance()
        
        audioSession.requestRecordPermission { [unowned self] allowed in
            if allowed {
                self.audioRecorder = try? AVAudioRecorder(url: self.recordingFilePath_m4a, settings: self.recordingSettings)
                if let recorder = self.audioRecorder {
                    recorder.delegate = self
                    if recorder.prepareToRecord() {
                        recorder.isMeteringEnabled = true
                        if recorder.record(forDuration: Double(60)) {
                            log.d("ok record!!")
                            self.state.toggle()
                            self.recordBtn.setTitle("녹음중", for: .normal)
                        }
                    }
                }
            }
        }
    }
    
    func stopRecordingAudio(){
        if let recoder = self.audioRecorder {
            self.recordBtn.setTitle("녹음하기", for: .normal)
            recoder.stop()
            self.state.toggle()
        }
    }
    
    func playAudio(){
        if let fileData = try? Data(contentsOf: self.recordingFilePath_m4a, options: .mappedIfSafe) {
            log.d(fileData)
            self.audioPlayer = try? AVAudioPlayer(data: fileData)
            
            if let player = self.audioPlayer {
                player.delegate = self
                
                if player.prepareToPlay() && player.play() {
                    log.d("재생 드가자~~")
                }
            }
        }
    }
    
    func audioToText(text: String) {
        self.audioTitleLabel.text = text
    }

    deinit {
        log.d("AudioRecordView deinitdeinitdeinitdeinitdeinitdeinitdeinitdeinit")
    }
}
