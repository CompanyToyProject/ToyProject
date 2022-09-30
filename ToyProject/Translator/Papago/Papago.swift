//
//  Papago.swift
//  ToyProject
//
//  Created by yeoboya-211221-05 on 2022/09/20.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire

class Papago {
    
    let detechURL = "https://openapi.naver.com/v1/papago/detectLangs"
    let translateURL = "https://openapi.naver.com/v1/papago/n2mt"
    
    
    func detechLanguage(text: String, completion: @escaping ((String) -> Void)){
        let paramas = ["query": text]
        let header = ["Content-Type":"application/x-www-form-urlencoded; charset=UTF-8",
                      
                      "X-Naver-Client-Id":"CJXJM3YdT2iEkC0kOyH0",
                      
                      "X-Naver-Client-Secret":"BwxnvjNQdT"]
        
        Alamofire.request(detechURL, method: .post, parameters: paramas, encoding: URLEncoding.default, headers: header).responseJSON { (response) in
            switch response.result {
            case .success(let result):
                let jsonData = JSON(result)
                log.d(jsonData)
                completion(jsonData["langCode"].stringValue)
            case .failure(let error):
                log.d(error)
                completion("변환 실패")
            }
        }
        
    }
    
    func translatedLanguage(text: String, sourceLanguage: String, targetLanguage: String = "en" ,completion: @escaping ((String) -> Void)){
        
        let params = ["source": sourceLanguage,
                      
                      "target": targetLanguage,
                      
                      "text": text]
        
        let header = ["Content-Type":"application/x-www-form-urlencoded; charset=UTF-8",
                      
                      "X-Naver-Client-Id":"CJXJM3YdT2iEkC0kOyH0",
                      
                      "X-Naver-Client-Secret":"BwxnvjNQdT"]
        
        log.d(params)
        
        Alamofire.request(translateURL, method: .post, parameters: params, encoding: URLEncoding.default, headers: header).responseJSON { (response) in
            switch response.result {
            case .success(let result):
                let jsonData = JSON(result)
                log.d(jsonData)
                if let translatedText = jsonData["message"]["result"]["translatedText"].string, translatedText != "" {
                    completion(translatedText)
                }
                else {
                    completion(text)
                }
            case .failure(let error):
                log.d(error)
            }
        }
    }
    
    func detechAndTranslate(text: String, completion: @escaping ((String) -> Void)){
        detechLanguage(text: text) { [unowned self] (sourceLanguage) in
            self.translatedLanguage(text: text, sourceLanguage: sourceLanguage) { (translatedText) in
                completion(translatedText)
            }
        }
    }
    
    
    
}
