//
//  Logger.swift
//  TestMap
//
//  Created by yeoboya on 2022/09/05.
//

import Foundation
import os.log
import SwiftyJSON

class log {
    private class config {
        static var systemLog : Active = .disable
        static var date : Active = .enable
        static var event : Active = .enable
        static var fileName : Active = .enable
        static var lineColum : Active = .enable
        static var funcName : Active = .enable
    }
    
    enum Active{
        case disable
        case enable
        
        var rawValue : Bool{
            switch self {
            case .disable: return false
            case .enable: return true
            }
        }
    }
        
    enum Event : String{
        case e = "‼️" // error
        case i = "📘" // info
        case d = "📔" // debug
        case v = "💬" // verbose
        case w = "⚠️" // warning
        case s = "🔥" // severe
    }
//    📕: error message
//    📙: warning message
//    📗: ok status message
//    📘: action message
//    📓: canceled status message
//    📔: Or anything you like and want to recognize immediately by color
///
    static var filter: String = "^-^"
    static var dateFormat = "yyyy-MM-dd hh:mm:ssSSS" // Use your own
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
    
   class func log(
        _ object: Any,
        date : String,
        event : String,
        sourceFileName: String,
        line: Int,
        column: Int,
        funcName: String) {
        let date = config.date.rawValue ? date : ""
        let event = config.event.rawValue ? event : ""
        let sourceFileName = config.fileName.rawValue ? "[\(sourceFileName)]" : ""
        let lineColum = config.lineColum.rawValue ? "\(line):\(column)" : ""
        let funcName = config.funcName.rawValue ? funcName : ""
    
        //setenv("OS_ACTIVITY_MODE", T##__value: UnsafePointer<Int8>!##UnsafePointer<Int8>!, T##__overwrite: Int32##Int32) 다시 enable 시켜줄수 있을것같음
        if let mode = getenv("OS_ACTIVITY_MODE"){
            if (strcmp(mode, "disable") == 0) { config.systemLog = .disable}
            else {config.systemLog = .enable }
        }else{
            config.systemLog = .enable
        }
    
        #if DEBUG
        if config.systemLog.rawValue{
            NSLog("\(lineColum) \(filter)\(event)\(sourceFileName) \(funcName) : \(object)")
        }else{
//            let lineCnt    = 200
            let lineCnt    = 100
            let separator  = "| \(date) | "
            let title      = "\(String(repeating: "=", count: 20)) [ \(event) \(funcName) : \(lineColum) : \(filter) \(date) \(event) :: \(sourceFileName)] "
            let inputBody  = "\(object)".replacingOccurrences(of: ",\"", with: ",\"\n").replacingOccurrences(of: "\\", with: "").components(separatedBy: ["\n"])
            
            var titleCnt  = lineCnt - title.count
            if titleCnt < 2 {
                titleCnt = 2
            }
            let header     = title + String(repeating: "=", count: titleCnt - 2)
            let footer     = String(repeating: "-", count: lineCnt)
            
            print(header)
            print("\(separator)\(inputBody.joined(separator: "\n" + separator ))")
            print(footer)
            print("\n")
        }
        #endif
    }
    

    class func e( _ object: Any,// 1
        filename: String = #file, // 2
        line: Int = #line, // 3
        column: Int = #column, // 4
        funcName: String = #function) {
        log(object, date: dateFormatter.string(from: Date()), event: Event.e.rawValue, sourceFileName: sourceFileName(filePath: filename), line: line, column: column, funcName: funcName)

    }
    class func i( _ object: Any,// 1
        filename: String = #file, // 2
        line: Int = #line, // 3
        column: Int = #column, // 4
        funcName: String = #function) {
        log(object, date: dateFormatter.string(from: Date()), event: Event.i.rawValue, sourceFileName: sourceFileName(filePath: filename), line: line, column: column, funcName: funcName)
        
    }
    
    class func d( _ object: Any,// 1
        filename: String = #file, // 2
        line: Int = #line, // 3
        column: Int = #column, // 4
        funcName: String = #function) {
        log(object, date: dateFormatter.string(from: Date()), event: Event.d.rawValue, sourceFileName: sourceFileName(filePath: filename), line: line, column: column, funcName: funcName)
        
    }
    
    class func d(_ object: Any, _ seconds: Any, filename: String = #file, // 2
                 line: Int = #line, // 3
                 column: Int = #column, // 4
                 funcName: String = #function) {
        
        log("\(object) \(seconds)", date: dateFormatter.string(from: Date()), event: Event.d.rawValue, sourceFileName: sourceFileName(filePath: filename), line: line, column: column, funcName: funcName)
        
    }
    
    class func v( _ object: Any,// 1
        filename: String = #file, // 2
        line: Int = #line, // 3
        column: Int = #column, // 4
        funcName: String = #function) {
        log(object, date: dateFormatter.string(from: Date()), event: Event.v.rawValue, sourceFileName: sourceFileName(filePath: filename), line: line, column: column, funcName: funcName)
        
    }
    
    class func w( _ object: Any,// 1
        filename: String = #file, // 2
        line: Int = #line, // 3
        column: Int = #column, // 4
        funcName: String = #function) {
        log(object, date: dateFormatter.string(from: Date()), event: Event.w.rawValue, sourceFileName: sourceFileName(filePath: filename), line: line, column: column, funcName: funcName)
        
    }
    
    class func s( _ object: Any,// 1
        filename: String = #file, // 2
        line: Int = #line, // 3
        column: Int = #column, // 4
        funcName: String = #function) {
        log(object, date: dateFormatter.string(from: Date()), event: Event.s.rawValue, sourceFileName: sourceFileName(filePath: filename), line: line, column: column, funcName: funcName)
        
    }
    
    
}

extension String {
    
    public func chunked(into size: Int) -> [SubSequence] {
        var chunks: [SubSequence] = []
        
        var i = startIndex
        
        while let nextIndex = index(i, offsetBy: size, limitedBy: endIndex) {
            chunks.append(self[i ..< nextIndex])
            i = nextIndex
        }
        
        let finalChunk = self[i ..< endIndex]
        
        if finalChunk.isEmpty == false {
            chunks.append(finalChunk)
        }
        
        return chunks
    }
}


