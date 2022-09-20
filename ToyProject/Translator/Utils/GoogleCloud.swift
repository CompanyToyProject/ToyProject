//
//  GoogleCloud.swift
//  ToyProject
//
//  Created by yeoboya-211221-05 on 2022/09/16.
//

import Foundation
import UIKit
import Alamofire
import SnapKit
import Then
import protoc_gen_grpc_swift
import GRPC
import SwiftProtobuf
import NIOCore
import NIOPosix
import Logging
import GoogleAPIClientForREST_Speech
import GoogleAPIClientForREST_Translate
import GoogleAPIClientForRESTCore

class GoogleCloud: UIView, AudioControllerDelegate {

    lazy var mainView = UIView().then{
        $0.backgroundColor = .white
    }

    lazy var mediaView = UIView().then{
        $0.backgroundColor = .white
    }
    
    lazy var executeBtn = UIButton().then{
        $0.setTitle("음성 스타트", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    lazy var stopBtn = UIButton().then{
        $0.setTitle("음성 스탑", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    let sample_rate = 16000
    var audioData: NSMutableData!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setView()
        setConstraints()
        bind()
        AudioController.sharedInstance.delegate = self
    }
    
    private func setView(){
        addSubview(mainView)

        mainView.addSubview(mediaView)
        
        [executeBtn, stopBtn].forEach{
            mediaView.addSubview($0)
        }
    }
    
    private func setConstraints(){


    }
    
    private func bind(){
   
    }
    
    private func firstSetting(){
        let group = PlatformSupport.makeEventLoopGroup(loopCount: 1)
        
        var logger = Logger(label: "gRPC", factory: StreamLogHandler.standardOutput(label:))
        logger.logLevel = .debug
        
        let channel = ClientConnection.usingPlatformAppropriateTLS(for: group).withBackgroundActivityLogger(logger).connect(host: "speech.googleapis.com", port: 443)
        
        let callOptions = CallOptions(customMetadata: [
            "x-goog-api-key" : "AIzaSyDvY8BSf0-Zz7rkfUmP0fNYlwi1GrLlb2M"
        ], logger: logger)
        
        let locale = Locale(identifier: Locale.preferredLanguages.first!)
        
        let config = GTLRSpeech_RecognitionConfig()
        config.encoding = "LINEAR16"
        config.languageCode = locale.languageCode
        config.sampleRateHertz = (sample_rate as NSNumber)
        config.maxAlternatives = 1
        
        let audio = GTLRSpeech_RecognitionAudio()
        audio.content = audioData.base64EncodedString()
        
        let request = GTLRSpeech_RecognizeRequest()
        request.config = config
        request.audio = audio
        
        
//        let intercptors = ClientInterceptor()
        
//        channel.makeCall(path: "", type: .unary, callOptions: callOptions, interceptors: [])
        

    }
    
    func processSampleData(_ data: Data) {
        
    }
    
    func audioSessionToData(_ data: Data) {
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
