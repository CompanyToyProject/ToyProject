//
//  LocalCoordinate+CoreDataProperties.swift
//  
//
//  Created by yeoboya on 2022/09/21.
//
//

import Foundation
import CoreData


extension LocalCoordinate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocalCoordinate> {
        return NSFetchRequest<LocalCoordinate>(entityName: "LocalCoordinate")
    }

    @NSManaged public var coordX: Int16
    @NSManaged public var coordY: Int16
    @NSManaged public var latitude: Double
    @NSManaged public var level1: String?
    @NSManaged public var level2: String?
    @NSManaged public var level3: String?
    @NSManaged public var longitude: Double
    @NSManaged public var weatherInfo: NSSet?

    var localFullString: String {
        guard let level1 = level1,
              let level2 = level2,
              let level3 = level3 else {
            return ""
        }

        return "\(level1) \(level2) \(level3)"
    }
    
    func toString() -> String {
        guard let level1 = level1,
              let level2 = level2,
              let level3 = level3 else {
            return "NO DATA"
        }
        return  "1단계: \(level1), 2단계: \(level2), 3단계: \(level3)\n" +
                "좌표: (\(coordX), \(coordY))\n" +
                "위도, 경도: (\(latitude), \(longitude))\n"
    }


}

// MARK: Generated accessors for weatherInfo
extension LocalCoordinate {

    @objc(addWeatherInfoObject:)
    @NSManaged public func addToWeatherInfo(_ value: Weather)

    @objc(removeWeatherInfoObject:)
    @NSManaged public func removeFromWeatherInfo(_ value: Weather)

    @objc(addWeatherInfo:)
    @NSManaged public func addToWeatherInfo(_ values: NSSet)

    @objc(removeWeatherInfo:)
    @NSManaged public func removeFromWeatherInfo(_ values: NSSet)

}
