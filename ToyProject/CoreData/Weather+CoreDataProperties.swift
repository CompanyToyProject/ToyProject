//
//  Weather.swift
//  ToyProject
//
//  Created by yeoboya on 2022/09/20.
//

import Foundation
import CoreData

extension Weather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Weather> {
        return NSFetchRequest<Weather>(entityName: "Weather")
    }

    @NSManaged public var date: Date?
    @NSManaged public var t1h: String?
    @NSManaged public var sky: String?
    @NSManaged public var reh: String?
    @NSManaged public var pty: String?
    @NSManaged public var rn1: String?
    @NSManaged public var localCoordinate: NSSet?

}
