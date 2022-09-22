//
//  ViewController.swift
//  ToyProject
//
//  Created by yeoboya on 2022/09/15.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreData
import SwiftyJSON
import CoreXLSX

class ViewController: UIViewController {
    
    var container: NSPersistentContainer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.container = PersistenceManager.shared.persistentContainer
    }
    
    @IBAction func clickGooglePlaces(_ sender: Any) {
        
        getLocalCoordinateDataFromXlsx {
            DispatchQueue.main.async {
                let storyBoard = UIStoryboard(name: "GoogleMapView", bundle: nil)
                guard let vc = storyBoard.instantiateViewController(withIdentifier: "GoogleMapView") as? GoogleMapViewController else {
                    return
                }
                getNavigationController().pushViewController(vc, animated: true)
            }
        }
    }
    
    @IBAction func clickWeatherHistory(_ sender: Any) {
        let vc = WeatherHistoryViewController()
        getNavigationController().pushViewController(vc, animated: true)
    }
    
    func getLocalCoordinateDataFromXlsx(completeHandler: @escaping (() -> Void)) {
        let request: NSFetchRequest<LocalCoordinate> = LocalCoordinate.fetchRequest()
        let fetchResult = PersistenceManager.shared.fetch(request: request)
        
        if fetchResult.isEmpty {
            let loading = LoadingViewController.shared
            loading.loadingViewSetting(view: self.view, delay: .seconds(0))
            loading.startLoading {
                DispatchQueue.global(qos: .userInitiated).async {
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
                        completeHandler()
                    } catch {
                        Toast.show("지역 데이터를 가져오지 못했습니다")
                        log.d(error.localizedDescription)
                    }
                    
                    print("[ CoreData에 저장 완료! ] \(String(repeating: "==", count: 20))")
                }
            }
        }
        else {
            log.d("CoreData에 저장된 데이터 존재")
            completeHandler()
        }
    }
}


