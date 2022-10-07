//
//  GoogleTranslation.swift
//  ToyProject
//
//  Created by yeoboya-211221-05 on 2022/10/06.
//

import Foundation
import UIKit
import GoogleAPIClientForREST_Translate
import GRPC
import Logging
import GoogleSignIn

class GoogleTranslation {
    
    private var client: Google_Cloud_Translation_V3_TranslationServiceNIOClient!
    private var logger: Logger!
    private var accessToken : String = ""
    
    init(){
        precondition(!GoogleCloudModel.clientID.isEmpty, "Google Client ID is Missing. Please Enter Your API Key")
        
        // 특정 플랫폼에 대한 이벤트 루프 그룹 만들기(iOS용 NIOTSeventLoopGroup)
        // 자세한 내용은 https://github.com/grpc/grpc-swift/blob/main/docs/apple-platforms.md 을 참조하십시오.
        let group = PlatformSupport.makeEventLoopGroup(loopCount: 1)
        
        var grpcLogger = Logger(label: "gRPC", factory: StreamLogHandler.standardError(label:))
        grpcLogger.logLevel = .debug
        
        self.logger = grpcLogger
        
        // '이벤트루프 그룹'에서 실행되는 구글의 음성 서비스에 TLS로 보안된 연결 만들기
        // TLS(Transport Layer Security) : 전송계층보안 -> 웹 서버와 브라우저 또는 앱과 같은 웹 클라이언트 간에 암호화된 링크를 설정하기 위한 표준 보안 기술
        let channel = ClientConnection
            .usingPlatformAppropriateTLS(for: group)
            .withBackgroundActivityLogger(self.logger)
            .connect(host: "translation.googleapis.com", port: 443)
        
        // client 초기화 - 이제 이걸 이용해서 통신한다.
        self.client = Google_Cloud_Translation_V3_TranslationServiceNIOClient(channel: channel)
    }
    
    // 로그인 인증 작업. Oauth 2.0을 발급하기 위해선 일단 구글 로그인 토큰으로 처리한다. 추후에 찾아봐서 수정예정
    func checkToken(completion: @escaping ((Bool) -> Void)){
        if accessToken.isEmpty {
            let config = GIDConfiguration(clientID: GoogleCloudModel.clientID)
            
            GIDSignIn.sharedInstance.signIn(with: config, presenting: getVisibleViewController()) { (user, error) in
                guard error == nil else { return }
                guard let user = user else { return }
                
                user.authentication.do { (authentication, error) in
                    guard error == nil else { return }
                    guard let auth = authentication else { return }
                    
                    log.d("auth.accessToken : \(auth.accessToken)")
                    self.accessToken = auth.accessToken
                    completion(true)
                }
            }
        }
        else {
            log.d("accessToken is \(self.accessToken)")
            completion(true)
        }
    }
    
    func goTranslated(_ text: String, sourceLanguage: String ,targetLanguage: String, completion: @escaping ((String) -> Void)){
        // 단순 번역을 사용하는 거라면 TranslateTextRequest를 이용해 통신. 다른 방법은 https://cloud.google.com/translate/docs/reference/rpc/google.cloud.translation.v3#google.cloud.translation.v3.TranslateTextRequest 참고.
        let request = Google_Cloud_Translation_V3_TranslateTextRequest.with{
            $0.sourceLanguageCode = sourceLanguage == "언어 감지" ? Locale.preferredLanguages.first! : sourceLanguage
            $0.targetLanguageCode = targetLanguage
            $0.mimeType = "text/plain"
            $0.contents = [text]
            $0.parent = "projects/hidden-pad-361207"
        }
        
        // gRPC 호출에 사용할 호출 옵션 지정. Translation v3 은 metaData에 api key가 필요없고 Oauth 2.0 인증이 필요하므로 Authorization을 넣어줘야한다.
        // 자세한건 https://cloud.google.com/apis/docs/system-parameters 참조.
        let callOptions = CallOptions(customMetadata: [
            "Authorization" : "Bearer \(accessToken)"
        ], logger: self.logger)
        
        
        let call = self.client.translateText(request, callOptions: callOptions).response.always { (response) -> Void in
            switch response {
            case .success(let response):
                log.d("response : \(response)")
                guard let translatedText = response.translations.first?.translatedText else {
                    return completion("번역 실패하였습니다.")
                }
                completion(translatedText)
            case .failure(let error):
                log.e("error : \(error)")
                completion("번역 실패 erorr 코드 : \(error.localizedDescription)")
            }
        }

    }
}
