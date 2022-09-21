//
//  GoogleMapViewModel+Data.swift
//  TestMap
//
//  Created by yeoboya on 2022/09/14.
//

import Foundation
import SwiftyJSON
import CoreData

extension GoogleMapViewModel {
    func getWeatherInfo(predicate: NSPredicate?, completion: @escaping ([WeatherInfo]) -> Void) {
        var items = [WeatherInfo]()
        var index = 0
        
        let request: NSFetchRequest<LocalCoordinate> = LocalCoordinate.fetchRequest()
        request.predicate = predicate
        let fetchResult = PersistenceManager.shared.fetch(request: request)
        
        func getData() {
            getWeatherInfoFromServer(fetchResult[index]) { [weak self] info in
                guard let self = self else { return }
                if let info = info  {
                    items.append(info)
                }
                
                index += 1
                if index >= fetchResult.count {
                    completion(items)
                    self.output?.weatherInfoDatas.accept(items)
                } else {
                    getData()
                }
                
            }
        }
    
        getData()
        
    }
    
    func getWeatherInfoFromServer(_ localCoordinate: LocalCoordinate,
                                  _baseDate: String? = nil,
                                  _baseTime: String? = nil,
                                  completion: @escaping ((WeatherInfo?) -> Void)) {
        
        var baseHour = 0
        var baseDate = ""
        var baseTime = ""
        if _baseTime == nil || _baseDate == nil {
            let formatter = DateFormatter()
            let now = Date()
            
            formatter.dateFormat = "yyyyMMdd"
            baseDate = formatter.string(from: now)
            
            formatter.dateFormat = "HH"
            baseHour = Int(formatter.string(from: now))!
            
            formatter.dateFormat = "mm"
            var baseMinute = Int(formatter.string(from: now))!
            
             if baseMinute < 45 {
                 baseHour -= 1
                 baseMinute = 30
             } else {
                 baseMinute = 30
             }
            
            baseTime = "\(String(format: "%02d", baseHour))\(baseMinute)"
        } else {
            baseDate = _baseDate!
            baseTime = _baseTime!
        }
        
        let path = weather_ultraFcst_url +
        "?serviceKey=\(SERVICE_KEY)" +
        "&numOfRows=\(1000)" +
        "&dataType=JSON" +
        "&base_date=\(baseDate)" +
        "&base_time=\(baseTime)" +
        "&nx=\(localCoordinate.coordX)" +
        "&ny=\(localCoordinate.coordY)"
        
        HttpManager.requestPlain(path, method: .get) { (_data) in
            guard let result = _data else {
                completion(nil)
                log.d("NO DATA")
                return
            }
            
            let data = JSON(result)["response"]
            let resultcode = data["header"]["resultCode"].stringValue
            
            if resultcode == "00" {
                let items = data["body"]["items"]["item"]
                guard var itemDatas = try? JSONDecoder().decode([MeteorologicalItem].self, from: items.rawData() ) else {
                    return
                }
                let baseTime = "\(String(format: "%02d", baseHour+1))00"
                
                itemDatas = itemDatas
                    .filter({ item in
                        if item.fcstDate == baseDate,
                           item.fcstTime == baseTime {
                            return true
                        }
                        return false
                    })
                
                var weatherJSON = JSON()
                itemDatas.forEach { item in
                    weatherJSON[item.category].string = item.fcstValue
                }
                
                guard var weatherInfo = try? JSONDecoder().decode(WeatherInfo.self, from: weatherJSON.rawData()) else {
                    return
                }
                weatherInfo.localCoordinate = localCoordinate
                weatherInfo.date = "\(baseDate) \(baseTime)"
                print("weatherInfo: \(weatherInfo)")
                
                completion(weatherInfo)
                
            }
            else {
                completion(nil)
                log.d("[ERROR] resultCode: \(resultcode), msg: \(data["header"]["resultMsg"].stringValue)")
            }
        }
        log.d(localCoordinate.toString())
    }
}
