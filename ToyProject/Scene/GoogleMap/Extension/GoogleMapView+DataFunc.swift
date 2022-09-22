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
        
        let loadLocalBtn = UIButton(type: .system)
        loadLocalBtn.setTitle("loadLocal", for: .normal)
        loadLocalBtn.addTarget(self, action: #selector(loadLocalData(_:)), for: .touchUpInside)
        
        [
            loadBtn,
            deleteAllBtn,
            loadLocalBtn
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
        
        loadLocalBtn.snp.makeConstraints { make in
            make.top.equalTo(deleteAllBtn.snp.bottom).offset(10)
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
        
//        let request: NSFetchRequest<LocalCoordinate> = LocalCoordinate.fetchRequest()
        let predicate = NSPredicate(format: "level3 == %@", "운남동")
//        request.predicate = predicate
//        let fetchResult = PersistenceManager.shared.fetch(request: request)
//
//        fetchResult.forEach { info in
//            log.d(info.toString())
//            log.d(info.weatherInfo)
//        }
        
        let request : NSFetchRequest<LocalCoordinate> = LocalCoordinate.fetchRequest()
        request.predicate = predicate
        let fetchRes = PersistenceManager.shared.fetch(request: request)
        
        fetchRes.forEach { item in
            guard let infos = item.weatherInfo?.array as? [Weather] else { return }
            infos.forEach { info in
                guard let date = info.date,
                      let t1h = info.t1h,
                      let sky = info.sky,
                      let reh = info.reh,
                      let pty = info.pty,
                      let rn1 = info.rn1,
                      let localCoordinate = info.localCoordinate else {
                    log.d(info)
                    return
                }

                let str =   "\n[Date: \(date.toString)] =================== \n" +
                            "온도: \(t1h), 하늘: \(sky), 습도: \(reh), 강수형태: \(pty), 1시간 강수량: \(rn1)\n" +
                "localFullString: \(localCoordinate.toString())"
                log.d(str)
            }
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
    
    @objc func loadLocalData(_ sender: UIButton) {
        let request : NSFetchRequest<LocalCoordinate> = LocalCoordinate.fetchRequest()
        let predicate = NSPredicate(format: "NONE weatherInfo == nil")
        request.predicate = predicate
        let fetchRes = PersistenceManager.shared.fetch(request: request)
        
        fetchRes.forEach {
            print("hasWeatherItem: \($0.localFullString)")
        }
    }
}
