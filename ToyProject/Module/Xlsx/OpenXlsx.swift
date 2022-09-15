//
//  OpenXlsx.swift
//  TestMap
//
//  Created by yeoboya on 2022/09/06.
//

import Foundation
import CoreXLSX

class OpenXlsx {
    
    public var fileName: String
    public var fileType: String
    public let filePath: String?
    
    init(fileName: String,
         fileType: String,
         filePath: String?) {
        self.fileName = fileName
        self.fileType = fileType
        self.filePath = Bundle.main.path(forResource: fileName, ofType: fileType)
    }
    
    convenience init() {
        self.init(fileName: "meteorological_service", fileType: "xlsx", filePath: nil)
    }
    
    func openXlsxTest() {
        if let fPath = self.filePath {
            guard let file = XLSXFile(filepath: fPath) else {
                fatalError("XLSX file at \(String(describing: self.filePath)) is corrupted or does not exist")
            }
            
            do {
                for wbk in try file.parseWorkbooks() {
                    for (name, path) in try file.parseWorksheetPathsAndNames(workbook: wbk) {
                        if let worksheetName = name {
                            print("\(worksheetName)")
                        }
                        
                        let worksheet = try file.parseWorksheet(at: path)
                        
                        if let sharedStrings = try file.parseSharedStrings() {
                            log.d("sharedStrings: \(sharedStrings)")
                            let columnECells = worksheet.cells(atColumns: [ColumnReference("E")!])
                            let columnEString = columnECells.map { $0.stringValue(sharedStrings) ?? "" }
                            print(columnEString)
                        }
                    }
                }
            }
            catch {
                log.d("error: \(error.localizedDescription)")
            }
        }
    }
    
    func getXlsxData() -> (Worksheet?, SharedStrings)? {
        if let fPath = self.filePath {
            guard let file = XLSXFile(filepath: fPath) else {
                fatalError("XLSX file at \(String(describing: self.filePath)) is corrupted or does not exist")
            }
            
            do {
                for wbk in try file.parseWorkbooks() {
                    for (name, path) in try file.parseWorksheetPathsAndNames(workbook: wbk) {
                        if let worksheetName = name {
                            print("\(worksheetName)")
                        }
                        
                        let worksheet = try file.parseWorksheet(at: path)
                        
                        if let sharedStrings = try file.parseSharedStrings() {
                            return (worksheet, sharedStrings)
                        }
                    }
                }
            }
            catch {
                log.d("error: \(error.localizedDescription)")
                return nil
            }
        }
        
        return nil
        
    }
}
