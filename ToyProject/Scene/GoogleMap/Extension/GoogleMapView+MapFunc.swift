//
//  GoogleMapView+MapFunc.swift
//  TestMap
//
//  Created by yeoboya on 2022/09/06.
//

import Foundation
import UIKit
import GoogleMaps
import CoreData
import SwiftyJSON

extension GoogleMapViewController {
    
    func getMarker(_ info: WeatherInfo) -> GMSMarker? {
        guard let localCoordinate = info.localCoordinate else { return nil }
        let coordinate = CLLocationCoordinate2D(latitude: localCoordinate.latitude, longitude: localCoordinate.longitude)

        let marker = GMSMarker(position: coordinate)
            marker.userData = info
        marker.title = localCoordinate.level1

        let markerView = WeatherMarkerView()
            markerView.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
            markerView.configView(info)

        marker.iconView = markerView
        
        return marker
    }
    
    func setMapButton() {
        let zoomInBtn = UIButton(type: .system)
        zoomInBtn.setTitle("ZoomIn", for: .normal)
        zoomInBtn.addTarget(self, action: #selector(zoomIn), for: .touchUpInside)
        
        let zoomOutBtn = UIButton(type: .system)
        zoomOutBtn.setTitle("ZoomOut", for: .normal)
        zoomOutBtn.addTarget(self, action: #selector(zoomOut), for: .touchUpInside)
        
        let toMyHomeBtn = UIButton(type: .system)
        toMyHomeBtn.setTitle("ToMyHome", for: .normal)
        toMyHomeBtn.addTarget(self, action: #selector(toMyHome), for: .touchUpInside)
        
        [
            zoomInBtn,
            zoomOutBtn,
            toMyHomeBtn
        ].forEach {
            $0.backgroundColor = .white
            self.view.addSubview($0)
        }
        
        zoomInBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(100)
            make.trailing.equalToSuperview().inset(10)
            make.height.equalTo(30)
        }
        
        zoomOutBtn.snp.makeConstraints { make in
            make.top.equalTo(zoomInBtn.snp.bottom).offset(10)
            make.trailing.equalTo(zoomInBtn)
            make.height.equalTo(30)
        }
        
        toMyHomeBtn.snp.makeConstraints { make in
            make.top.equalTo(zoomOutBtn.snp.bottom).offset(10)
            make.trailing.equalTo(zoomInBtn)
            make.height.equalTo(30)
        }
    }
    
    @objc func zoomIn(_ sender: UIButton) {
        let zoomCamera = GMSCameraUpdate.zoomIn()
        mapView.animate(with: zoomCamera)
    }
    
    @objc func zoomOut(_ sender: UIButton) {
        let zoomCamera = GMSCameraUpdate.zoomOut()
        mapView.animate(with: zoomCamera)
    }
    
    @objc func toMyHome(_ sender: UIButton) {
        let myHome = CLLocationCoordinate2D(latitude: 35.17829730107765, longitude: 126.82638581452069)
        let myHomeCam = GMSCameraUpdate.setTarget(myHome, zoom: 17)
        
        mapView.animate(with: myHomeCam)
    }
}
