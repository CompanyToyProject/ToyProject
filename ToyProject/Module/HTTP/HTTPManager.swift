//
//  HTTPManager.swift
//  TestMap
//
//  Created by yeoboya on 2022/09/07.
//

import Foundation
import Alamofire
import SwiftyJSON

public typealias HttpParameters = [String : AnyObject]
public typealias HttpSuccessClosure = (AnyObject) -> Void
public typealias HttpFailureClosure = (NSError) -> Void

public let SERVICE_KEY = "KhboHZT7b5HQlsYzDCKTKjI3SaTi1K87kXu1KRmcNDClC043vu8nWRXremhuhAUgGd%2Bazw%2BxYS9h0ZIQDU6NNQ%3D%3D"
public let weather_base_url = "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0"
public let weather_ultraNcst_url = weather_base_url + "/getUltraSrtNcst"    // 단기 실황
public let weather_ultraFcst_url = weather_base_url + "/getUltraSrtFcst"    // 초단기 예보
public let weather_vilageFcst_url = weather_base_url + "/getVilageFcst"     // 단기 예보

class HttpManager: NSObject {
    class func requestPlain(
        _ path: String,
        method : HTTPMethod = .post,
        logged : Bool = false,
        parameters: [String: Any]? = nil,
        completion: ((_ response: Any?) ->Void)? = nil){
            
        log.d("path : \(path)")
        log.d("parameters : \(parameters)")
        Alamofire.request(
            path,
            method     : method,
            parameters : parameters ?? [:])
            .responseJSON(completionHandler: {
                response in
                let completionHandler = completion ?? {_ in}
                switch response.result {
                case .success(let data):
                    if logged {
                      log.d(JSON(data))
                    }
                    completionHandler(data)
                case .failure(let error):
                    log.e(error)
                    completionHandler(nil)
                }
            })
    }
    
    
    class func requestPlain(
        _ path: String,
        method : HTTPMethod = .post,
        logged : Bool = false,
        parameters: [String: AnyObject]? = nil,
        completion: ((_ response: Any?) ->Void)? = nil){
        log.d("path : \(path)")
        log.d("path : \(parameters)")
        Alamofire.request(
            path,
            method     : method,
            parameters : parameters ?? [:],
            encoding: URLEncoding.default)
            .responseJSON(completionHandler: {
                response in
                let completionHandler = completion ?? {_ in}
                switch response.result {
                case .success(let data):
                    if logged {
                      log.d(JSON(data))
                    }
                    completionHandler(data)
                case .failure(let error):
                    log.e(error)
                    completionHandler(nil)
                }
            })
    }
    
    class func requestPlainString(
        _ path: String,
        method : HTTPMethod = .get,
        logged : Bool = false,
        parameters: [String: Any]? = nil,
        completion: ((_ response: Any?) ->Void)? = nil){
        log.d(path)
        Alamofire.request(
            path,
            method     :  method,
            parameters : parameters ?? [:])
            //encoding   : JSONEncoding.default,)
            .responseString{
                response in
                let completionHandler = completion ?? {_ in}
                switch response.result {
                case .success(let data):
                    if logged {
                      log.d(JSON(data))
                    }
                    completionHandler(data)
                    return
                case .failure(let error):
                    completionHandler(nil)
                    log.e(error)
                }
            }
    }
    
    class func requestJSON(
        _ path: String,
        method : HTTPMethod = .post,
        logged : Bool = false,
        parameters: [String: Any]? = nil,
        completion: ((_ response: Any?) ->Void)? = nil){
        log.d(path)
        Alamofire.request(
            path,
            method     :  method,
            parameters : parameters ?? [:],
            encoding   : JSONEncoding.default)
            .responseJSON{
                response in
                let completionHandler = completion ?? {_ in}
                switch response.result {
                case .success(let data):
                    if logged {
                      log.d(JSON(data))
                    }
                    completionHandler(data)
                    return
                case .failure(let error):
                    completionHandler(nil)
                    log.e(error)
                }
            }
    }
}
