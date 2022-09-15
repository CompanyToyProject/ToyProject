//
//  GoogleMapView+DataFunc.swift
//  TestMap
//
//  Created by yeoboya on 2022/09/06.
//

import Foundation
import UIKit
import CoreData
import CoreXLSX
import SwiftyJSON

extension GoogleMapViewController {
    
    func getLocalCoordinateDataFromXlsx() {
        let request: NSFetchRequest<LocalCoordinate> = LocalCoordinate.fetchRequest()
        let fetchResult = PersistenceManager.shared.fetch(request: request)
        
        if fetchResult.isEmpty {
            let xlsx = OpenXlsx()
            
            guard let (worksheet, sharedStrings) = xlsx.getXlsxData(),
                  let worksheet = worksheet else {
                return
            }
            
            let searchColumnString = ["C", "D", "E", "F", "G", "N", "O"]
            
            var baseJSON = JSON()
            for string in searchColumnString {
                var columnString = worksheet.cells(atColumns: [ColumnReference(string)!])
                    .map { $0.stringValue(sharedStrings) ?? "" }
                    columnString.removeFirst()
                let columnJSON = JSON(columnString)
                baseJSON[string] = columnJSON
                print("[ \(string)열 JSON 변환 완료 ] \(String(repeating: "==", count: 20))")
            }
            
            print("[ CoreData에 저장중... ] \(String(repeating: "==", count: 20))")
            for index in 0..<baseJSON["C"].arrayValue.count {
                var data = JSON()
                for string in searchColumnString {
                    data[string] = baseJSON[string][index]
                }
                
                let entity = NSEntityDescription.entity(forEntityName: "LocalCoordinate", in: self.container.viewContext)!
                let row = NSManagedObject(entity: entity, insertInto: self.container.viewContext)
                row.setValue(data["C"].stringValue, forKey: "level1")
                row.setValue(data["D"].stringValue, forKey: "level2")
                row.setValue(data["E"].stringValue, forKey: "level3")
                row.setValue(data["F"].intValue, forKey: "coordX")
                row.setValue(data["G"].intValue, forKey: "coordY")
                row.setValue(data["O"].doubleValue, forKey: "latitude")
                row.setValue(data["N"].doubleValue, forKey: "longitude")
            }

            do {
                try self.container.viewContext.save()
            } catch {
                log.d(error.localizedDescription)
            }
            
            print("[ CoreData에 저장 완료! ] \(String(repeating: "==", count: 20))")
        }
        else {
            log.d("CoreData에 저장된 데이터 존재")
        }
    }
    
    func setCoreDataBtn() {
        let loadBtn = UIButton(type: .system)
        loadBtn.setTitle("loadCoreData", for: .normal)
        loadBtn.addTarget(self, action: #selector(loadData(_:)), for: .touchUpInside)
        
        let deleteAllBtn = UIButton(type: .system)
        deleteAllBtn.setTitle("deleteAllData", for: .normal)
        deleteAllBtn.addTarget(self, action: #selector(deleteAllData(_:)), for: .touchUpInside)
        
        [
            loadBtn,
            deleteAllBtn
        ].forEach {
            $0.backgroundColor = .white
            self.view.addSubview($0)
        }
        
        loadBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(100)
            make.trailing.equalToSuperview().inset(10)
            make.height.equalTo(30)
        }
        
        deleteAllBtn.snp.makeConstraints { make in
            make.top.equalTo(loadBtn.snp.bottom).offset(10)
            make.trailing.equalTo(loadBtn)
            make.height.equalTo(30)
        }
    }
    
    @objc func loadData(_ sender: UIButton) {
        
        let request: NSFetchRequest<LocalCoordinate> = LocalCoordinate.fetchRequest()
        request.predicate = NSPredicate(format: "latitude BEGINSWITH %@", "35.170")
        let fetchResult = PersistenceManager.shared.fetch(request: request)

        fetchResult.forEach {
            log.d($0.toString())
        }
    }
    
    @objc func deleteAllData(_ sender: UIButton) {        
        let request : NSFetchRequest<LocalCoordinate> = LocalCoordinate.fetchRequest()
        PersistenceManager.shared.deleteAll(request: request)
        let arr = PersistenceManager.shared.fetch(request: request)
        if arr.isEmpty {
            log.d("Clean LocalCoordinate CoreData")
        }
    }
}
