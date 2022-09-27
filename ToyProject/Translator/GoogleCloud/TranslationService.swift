//
//  TranslationService.swift
//  ToyProject
//
//  Created by yeoboya-211221-05 on 2022/09/27.
//

import Foundation
import UIKit
import GRPC
import Logging

class TranslationService {
    
    private var client: Google_Cloud_Translation_V3_TranslationServiceNIOClient
    
    init(){
        
        let group = PlatformSupport.makeEventLoopGroup(loopCount: 1)
        
        var logger = Logger(label: "gRPC", factory: StreamLogHandler.standardError(label:))
        logger.logLevel = .debug
        
        let channel = ClientConnection
            .usingPlatformAppropriateTLS(for: group)
            .withBackgroundActivityLogger(logger)
            .connect(host: "translate.googleapis.com", port: 443)
        
        let callOptions = CallOptions(customMetadata: [
            "x-goog-api-key" : GoogleCloudModel.apiKey
        ], logger: logger)
        
        self.client = Google_Cloud_Translation_V3_TranslationServiceNIOClient(channel: channel, defaultCallOptions: callOptions)
    }
    
    func getSupportedLanguage(){
        
        let request = Google_Cloud_Translation_V3_GetSupportedLanguagesRequest.with{
            $0.parent = ""
        }
        
        
        
    }
}
