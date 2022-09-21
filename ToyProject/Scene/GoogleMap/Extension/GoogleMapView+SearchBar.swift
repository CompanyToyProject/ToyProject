//
//  GoogleMapView+SearchBar.swift
//  ToyProject
//
//  Created by yeoboya on 2022/09/16.
//

import Foundation
import CoreData
import UIKit

extension GoogleMapViewController {
    func setSearchBarView() {
        searchBarView = SearchBarView()
        
        let request: NSFetchRequest<LocalCoordinate> = LocalCoordinate.fetchRequest()
        let fetchResult = PersistenceManager.shared.fetch(request: request)
        searchBarView.configUI(arr: fetchResult)
        
        self.view.addSubview(searchBarView)
        
        searchBarView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        searchBarView.selectItem
            .bind { [weak self] selectedLocal in
                guard let self = self else { return }
                log.d(selectedLocal.localFullString)
                
                let loading = LoadingViewController.shared
                loading.loadingViewSetting(view: self.view, delay: .seconds(1))
                loading.startLoading {
                    self.viewModel.getWeatherInfoFromServer(selectedLocal) { [weak self] info in
                        guard let self = self else { return }
                        guard let info = info else {
                            loading.endLoading()
                            Toast.show("날씨정보를 불러올 수 없습니다")
                            return
                        }
                        self.weatherInfo.onNext((info, true))
                        self.saveWeatherData(info)

                        loading.endLoading()
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    func hideSearchBar(_ isHidden: Bool = true) {
        if isHidden {
            let transform = CGAffineTransform(translationX: 0, y: -50)
            self.searchBarView.animHide(transform: transform) { _ in
                self.searchBarView.textView.text = ""
                self.navigationItem.rightBarButtonItem = self.rightBarButton
            }
        }
        else {
            self.searchBarView.tableViewZeroHeight()
            self.searchBarView.animShow()
            self.navigationItem.setRightBarButton(nil, animated: true)
        }
            
    }
    
    func saveWeatherData(_ info: WeatherInfo) {
        guard let date = info.date?.toDate else { return }
        guard let localCoordinate = info.localCoordinate else { return }
        
        let entity = NSEntityDescription.entity(forEntityName: "LocalCoordinate", in: self.container.viewContext)!
        let row = NSManagedObject(entity: entity, insertInto: self.container.viewContext)
        row.setValue(localCoordinate.level1, forKey: "level1")
        row.setValue(localCoordinate.level2, forKey: "level2")
        row.setValue(localCoordinate.level3, forKey: "level3")
        row.setValue(localCoordinate.coordX, forKey: "coordX")
        row.setValue(localCoordinate.coordY, forKey: "coordY")
        row.setValue(localCoordinate.latitude, forKey: "latitude")
        row.setValue(localCoordinate.longitude, forKey: "longitude")
        
        let weatherObj = NSEntityDescription.insertNewObject(forEntityName: "Weather", into: self.container.viewContext) as! Weather
        weatherObj.date = date
        weatherObj.t1h = info.T1H
        weatherObj.sky = info.SKY.rawValue
        weatherObj.reh = info.REH
        weatherObj.pty = info.PTY.rawValue
        weatherObj.rn1 = info.RN1
        
        (row as! LocalCoordinate).addToWeatherInfo(weatherObj)
        
        do {
            try self.container.viewContext.save()
        } catch {
            Toast.show("저장 실패 가져오지 못했습니다")
            log.d(error.localizedDescription)
        }
    }

}
