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

class AudioRecordView: UIView {
    
    lazy var kingView = UIView().then{
        $0.backgroundColor = .white
    }
    
    lazy var mainView = UIView().then{
        $0.backgroundColor = .clear
    }
    
    lazy var recordBtn = UIButton().then{
        $0.setTitle("녹음하기", for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .white
    }
    
    var disposeBag = DisposeBag()
    
    let recordingFilePath_m4a = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true).appendingPathComponent("recording.m4a")
    let recordingFilePath_mp3 = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true).appendingPathComponent("recording.mp3")
    let recordingSettings = [
        AVFormatIDKey: NSNumber(value: Int32(kAudioFormatMPEG4AAC)),
        AVNumberOfChannelsKey: NSNumber(value: 2),
        AVSampleRateKey: NSNumber(value: Int32(44100)),
        AVEncoderAudioQualityKey: NSNumber(value: Int32(AVAudioQuality.max.rawValue))
    ]
    
    
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
    }
    
    private func setConstraints(){
        kingView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        mainView.snp.makeConstraints{
            $0.edges.equalTo(kingView.safeAreaLayoutGuide)
        }
    }
    
    private func firstSetting(){
        
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
    
    func getRecord(){
        
    }

    
    deinit {
        log.d("AudioRecordView deinitdeinitdeinitdeinitdeinitdeinitdeinitdeinit")
    }
}
