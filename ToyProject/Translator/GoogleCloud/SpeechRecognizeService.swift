//
//  SpeechRecognizeService.swift
//  ToyProject
//
//  Created by yeoboya-211221-05 on 2022/09/26.
//

import Foundation
import UIKit
import GRPC
import Logging

typealias SpeechRequest = Google_Cloud_Speech_V1_StreamingRecognizeRequest
typealias SpeechResponse = Google_Cloud_Speech_V1_StreamingRecognizeResponse
typealias SpeechRecognizeCall = BidirectionalStreamingCall

class SpeechRecognizeService {
    
    enum State {
        case idle
        case streaming(SpeechRecognizeCall<SpeechRequest, SpeechResponse>)
    }
    
    private var client: Google_Cloud_Speech_V1_SpeechNIOClient
    private var state: State = .idle
    
    init(){
        precondition(!GoogleCloudModel.apiKey.isEmpty, "Google Cloud API Key is Missing. Please Enter Your API Key")
        
        // 특정 플랫폼에 대한 이벤트 루프 그룹 만들기(iOS용 NIOTSeventLoopGroup)
        // 자세한 내용은 https://github.com/grpc/grpc-swift/blob/main/docs/apple-platforms.md 을 참조하십시오.
        let group = PlatformSupport.makeEventLoopGroup(loopCount: 1)
        
        var logger = Logger(label: "gRPC", factory: StreamLogHandler.standardError(label:))
        logger.logLevel = .debug
        
        // '이벤트루프 그룹'에서 실행되는 구글의 음성 서비스에 TLS로 보안된 연결 만들기
        // TLS(Transport Layer Security) : 전송계층보안 -> 웹 서버와 브라우저 또는 앱과 같은 웹 클라이언트 간에 암호화된 링크를 설정하기 위한 표준 보안 기술
        let channel = ClientConnection
            .usingPlatformAppropriateTLS(for: group)
            .withBackgroundActivityLogger(logger)
            .connect(host: "speech.googleapis.com", port: 443)
        
        // gRPC 호출에 사용할 호출 옵션 지정
        let callOptions = CallOptions(customMetadata: [
            "x-goog-api-key" : GoogleCloudModel.apiKey
        ], logger: logger)
        
        // client 초기화 - 이제 이걸 이용해서 통신한다.
        self.client = Google_Cloud_Speech_V1_SpeechNIOClient(channel: channel, defaultCallOptions: callOptions)
        
    }
    
    func getStreamResponse(_ data: NSData,_ languageCode: String = Locale.preferredLanguages.first! ,completion: ((Google_Cloud_Speech_V1_StreamingRecognizeResponse) -> Void)? = nil ) {
        switch self.state {
        case .idle:
            // 양방향 스트림 초기화
            let call = self.client.streamingRecognize { response in
                // 서버로부터 메세지가 도착하고, 클로저를 통해 response 전달
                completion?(response)
            }
            
            self.state = .streaming(call)
            log.d("languageCode : \(languageCode)")
            // 오디오 세부 정보 지정
            let config = Google_Cloud_Speech_V1_RecognitionConfig.with {
                $0.encoding = .linear16
                $0.sampleRateHertz = Int32(GoogleCloudModel.sampleRate)
                $0.languageCode = languageCode
                $0.enableAutomaticPunctuation = true   // true면 인식 결과 가설에 구두점을 추가한다. 기본값 'false'은 구두점 추가 X4
                $0.metadata = Google_Cloud_Speech_V1_RecognitionMetadata.with{
                    $0.interactionType = .dictation
                    $0.microphoneDistance = .nearfield
                    $0.recordingDeviceType = .smartphone
                }
            }
            
            // 스트리밍 요청 생성
            let request = Google_Cloud_Speech_V1_StreamingRecognizeRequest.with {
                $0.streamingConfig = Google_Cloud_Speech_V1_StreamingRecognitionConfig.with{
                    $0.config = config
                    $0.singleUtterance = false
                    $0.interimResults = true
                }
            }
            
            // 스트리밍 요청 세부 정보로 구성된 첫 번째 메시지 보내기
            call.sendMessage(request, promise: nil)
            
            // 오디오 세부 정보가 포함된 전송할 스트림 요청
            
            let streamAudioDataRequest = Google_Cloud_Speech_V1_StreamingRecognizeRequest.with{
                $0.audioContent = data as Data
            }
            
            // 오디오 데이터 전송
            call.sendMessage(streamAudioDataRequest, promise: nil)
            
        case let .streaming(call):
            // 오디오 세부 정보가 포함된 전송할 스트림 요청
            let streamAudioDataRequest = Google_Cloud_Speech_V1_StreamingRecognizeRequest.with{
                $0.audioContent = data as Data
            }
            
            // 오디오 데이터 전송
            call.sendMessage(streamAudioDataRequest, promise: nil)
        }
    }
    
    func stopStreaming(){
        switch self.state {
        case .idle:
            return
        case let .streaming(stream):
            stream.sendEnd(promise: nil)
            self.state = .idle
        }
    }
    
}
