//
//  Date+.swift
//  ToyProject
//
//  Created by yeoboya on 2022/09/21.
//

import Foundation

extension Date {
    var toString: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy년 MM월 dd일 HH시"
            dateFormatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
            
            return dateFormatter.string(from: self)
        }
    }
}
