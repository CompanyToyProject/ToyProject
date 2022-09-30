//
//  AudioFileToText.swift
//  ToyProject
//
//  Created by yeoboya-211221-05 on 2022/09/28.
//

import Foundation
import UIKit
import GoogleAPIClientForREST_Speech
import GoogleAPIClientForRESTCore
import Alamofire
import RxSwift
import SwiftyJSON
import GRPC
import Logging

class AudioFileToText {
    
    private var client: Google_Cloud_Speech_V1_SpeechNIOClient
    
    init(){
        
        let group = PlatformSupport.makeEventLoopGroup(loopCount: 1)
        
        var logger = Logger(label: "gRPC", factory: StreamLogHandler.standardError(label:))
        logger.logLevel = .debug
        
        let channel = ClientConnection
            .usingPlatformAppropriateTLS(for: group)
            .withBackgroundActivityLogger(logger)
            .connect(host: "speech.googleapis.com", port: 443)
        
        let callOptions = CallOptions(customMetadata: [
            "x-goog-api-key" : GoogleCloudModel.apiKey
        ], logger: logger)
        
        self.client = Google_Cloud_Speech_V1_SpeechNIOClient(channel: channel, defaultCallOptions: callOptions)
        
    }
    
    func getAudioText(_ data: Data){
        
        let call = self.client.streamingRecognize { (response) in
            log.d(response)
        }

        
        let config = Google_Cloud_Speech_V1_RecognitionConfig.with{
            $0.encoding = .linear16
            $0.enableWordTimeOffsets = true
            $0.languageCode = "ko-KR"
            $0.sampleRateHertz = Int32(GoogleCloudModel.sampleRate)
        }
        
        let request = Google_Cloud_Speech_V1_RecognizeRequest.with{
            $0.config = config
            $0.audio = Google_Cloud_Speech_V1_RecognitionAudio.with{
                $0.uri = "https://storage.cloud.google.com/gab_music/Summer%20Solstice%20on%20the%20June%20Planet%20-%20Bail%20Bonds.mp3"
            }
        }
        
        let call2 = self.client.recognize(request)
        
        
        
        _  = call2.response.always({ (response) in
            log.d(response)
        })

    }
    
    func test(){
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    func audioToText(){
        let recordingFilePath_m4a = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true).appendingPathComponent("recording.m4a")
        
        if let fileData = try? Data(contentsOf: recordingFilePath_m4a, options: .mappedIfSafe) {
            let header = [
                "Content-Type" : "application/json; charset=utf-8"
            ]

            let config = [
                "languageCode" : "ko-KR",
                "encoding" : "LINEAR16",
                "sampleRateHertz" : "\(16000)"
            ] as [String : Any]
            
            let request = [
                "content" : fileData.base64EncodedString()
            ]

            let requestDictinoary = [
                "config" : config,
                "audio" : request
            ]
            
            let speechAudio = GTLRSpeech_RecognitionAudio()
            speechAudio.content = fileData.base64EncodedString()

            let speechConfig = GTLRSpeech_RecognitionConfig()
            speechConfig.encoding = "LINEAR16"
            speechConfig.sampleRateHertz = 16000
            speechConfig.languageCode = "ko-KR"
            speechConfig.enableWordTimeOffsets = 1
            speechConfig.maxAlternatives = 30

            let speechRequest = GTLRSpeech_RecognizeRequest()
            speechRequest.config = speechConfig
            speechRequest.audio = speechAudio

            let bodyobject = GTLRObject(json: requestDictinoary)
//
            let query = GTLRSpeechQuery_SpeechRecognize(pathURITemplate: "v1/speech:recognize?key=AIzaSyDvY8BSf0-Zz7rkfUmP0fNYlwi1GrLlb2M", httpMethod: "POST", pathParameterNames: [""])
            query.additionalHTTPHeaders = header
            query.bodyObject = bodyobject
            
            
            let service = GTLRSpeechService()
            
            service.executeQuery(query) { (ticket, result ,error) in
                guard error == nil else {
                    log.d(error)
                    return
                }
                guard let result = result as? GTLRObject, let _json = result.json else { return }

                let jsonData = JSON(_json)
                log.d(jsonData)
            }
        }
        

    }
    
    
}
