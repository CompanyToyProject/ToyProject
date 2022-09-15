//
//  WeatherModel.swift
//  TestMap
//
//  Created by yeoboya on 2022/09/07.
//

import Foundation
import SwiftyJSON

/*
 "baseDate": "20220907",
 "baseTime": "1530",
 "category": "LGT",
 "fcstDate": "20220907",
 "fcstTime": "1600",
 "fcstValue": "0",
 "nx": 58,
 "ny": 75
 */

struct MeteorologicalItem: Codable {
    var category: String
    var fcstDate: String
    var fcstTime: String
    var fcstValue: String
    
    enum CodingKeys: String, CodingKey {
        case category
        case fcstDate
        case fcstTime
        case fcstValue
    }
    
    init(from decoder: Decoder) throws {
        do {
            let values      = try decoder.container(keyedBy: CodingKeys.self)
            category        = try values.decode(String.self, forKey: .category)
            fcstDate        = try values.decode(String.self, forKey: .fcstDate)
            fcstTime        = try values.decode(String.self, forKey: .fcstTime)
            fcstValue        = try values.decode(String.self, forKey: .fcstValue)
        }
        catch {
            print(error)
            throw error
        }
    }
}
