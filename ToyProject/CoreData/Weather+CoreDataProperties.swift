//
//  Weather.swift
//  ToyProject
//
//  Created by yeoboya on 2022/09/20.
//

import Foundation
import CoreData

extension Weather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherData> {
        return NSFetchRequest<WeatherData>(entityName: "Weather")
    }

    @NSManaged public var date: Date?
    @NSManaged public var t1h: String?
    @NSManaged public var sky: String?
    @NSManaged public var reh: String?
    @NSManaged public var pty: String?
    @NSManaged public var rn1: String?
    @NSManaged public var localCoordinate: NSSet?

}


// MARK: Generated accessors for localCoordinate
extension Weather {

    @objc(addLocalCoordinateObject:)
    @NSManaged public func addToLocalCoordinate(_ value: LocalCoordinate)

    @objc(removeLocalCoordinateObject:)
    @NSManaged public func removeFromLocalCoordinate(_ value: LocalCoordinate)

    @objc(addLocalCoordinate:)
    @NSManaged public func addToLocalCoordinate(_ values: NSSet)

    @objc(removeLocalCoordinate:)
    @NSManaged public func removeFromLocalCoordinate(_ values: NSSet)

}
