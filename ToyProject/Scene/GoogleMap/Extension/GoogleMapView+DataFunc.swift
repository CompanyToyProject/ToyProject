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
        
//        let request: NSFetchRequest<LocalCoordinate> = LocalCoordinate.fetchRequest()
//        request.predicate = NSPredicate(format: "latitude BEGINSWITH %@", "35.170")
//        let fetchResult = PersistenceManager.shared.fetch(request: request)
//
//        fetchResult.forEach {
//            log.d($0.toString())
//        }
        
        let request: NSFetchRequest<Weather> = Weather.fetchRequest()

        let fetchResult = PersistenceManager.shared.fetch(request: request)

        fetchResult.forEach { info in
            log.d(info)
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
