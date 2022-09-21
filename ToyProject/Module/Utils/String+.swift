//
//  String+.swift
//  TestMap
//
//  Created by yeoboya on 2022/09/07.
//

import Foundation

extension String {
    var base64Decode: String {
        get {
            if let decodedStr = NSData(base64Encoded: self, options: NSData.Base64DecodingOptions()),
                let str = NSString(data: decodedStr as Data, encoding: String.Encoding.utf8.rawValue){
                return str as String
            }else{
                return self
            }
        }
    }
    
    var toDate: Date? {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd HHmm"
            dateFormatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
            if let date = dateFormatter.date(from: self) {
                return date
            } else {
                return nil
            }
        }
    }

}
