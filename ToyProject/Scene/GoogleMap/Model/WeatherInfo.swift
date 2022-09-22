//
//  WeatherInfo.swift
//  TestMap
//
//  Created by yeoboya on 2022/09/08.
//

import Foundation
import UIKit

struct WeatherInfo: Codable {
    var T1H: String
    var RN1: String
    var SKY: SKY_CODE
    var REH: String
    var PTY: PTY_CODE
    var localCoordinate: LocalCoordinate?
    var date: String?
    
    var image: UIImage? {
        if PTY == .none {
            return SKY.image
        }
        else {
            return PTY.image
        }
    }
    
    var tempString: String {
        return "\(T1H)°C"
    }
    
    
    enum CodingKeys: String, CodingKey {
        case T1H
        case RN1
        case SKY
        case REH
        case PTY
        case localCoordinate
        case date
    }
    
    static func getDefault() -> Self {
        return WeatherInfo()
    }
    
    init() {
        T1H = "0"
        RN1 = "강수없음"
        SKY = .sunny
        REH = "0"
        PTY = .none
        localCoordinate = nil
        date = nil
    }
    
    init(from decoder: Decoder) throws {
        do {
            let values      = try decoder.container(keyedBy: CodingKeys.self)
            T1H             = try values.decode(String.self, forKey: .T1H)
            RN1             = try values.decode(String.self, forKey: .RN1)
            SKY             = try values.decode(SKY_CODE.self, forKey: .SKY)
            REH             = try values.decode(String.self, forKey: .REH)
            PTY             = try values.decode(PTY_CODE.self, forKey: .PTY)
            localCoordinate = nil
            date            = nil
        }
        catch {
            print(error)
            throw error
        }
    }
   
}

enum SKY_CODE: String, Codable {
    case sunny = "1"
    case cloudiness = "3"
    case cloudy = "4"
    
    var toString: String {
        switch self {
        case .sunny:
            return "맑음"
        case .cloudiness:
            return "구름많음"
        case .cloudy:
            return "흐림"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .sunny:
            return UIImage(systemName: "sun.max.fill")
        case .cloudiness:
            return UIImage(systemName: "smoke.fill")
        case .cloudy:
            return UIImage(systemName: "cloud.sun.fill")
        }
    }
}

enum PTY_CODE: String, Codable {
    case none = "0"
    case rain = "1"
    case sleet = "2"
    case snowflake = "3"
    case drizzle = "5"
    case hail = "6"
    case snow = "7"
    
    var toString: String {
        switch self {
        case .none:
            return ""
        case .rain:
            return "비"
        case .sleet:
            return "비와 눈"
        case .snowflake:
            return "눈"
        case .drizzle:
            return "빗방울"
        case .hail:
            return "빗방울 눈날림"
        case .snow:
            return "눈날림"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .none:
            return UIImage(systemName: "house")
        case .rain:
            return UIImage(systemName: "cloud.rain.fill")
        case .sleet:
            return UIImage(systemName: "cloud.sleet.fill")
        case .snowflake:
            return UIImage(systemName: "snowflake")
        case .drizzle:
            return UIImage(systemName: "cloud.drizzle.fill")
        case .hail:
            return UIImage(systemName: "cloud.hail.fill")
        case .snow:
            return UIImage(systemName: "cloud.snow.fill ")
        }
    }
}
