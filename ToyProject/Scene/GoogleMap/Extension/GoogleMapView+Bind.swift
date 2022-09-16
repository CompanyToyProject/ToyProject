//
//  GoogleMapView+Bind.swift
//  TestMap
//
//  Created by yeoboya on 2022/09/14.
//

import Foundation
import RxSwift
import RxCocoa
import CoreData
import GoogleMaps

extension GoogleMapViewController {
    func bind() {
        guard let output = viewModel.output else { return }
        
        rightBarButton.rx.tap
            .throttle(.seconds(2), latest: false, scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.hideSearchBar(false)
            }
            .disposed(by: disposeBag)
        
        leftBarButton.rx.tap
            .throttle(.seconds(2), latest: false, scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] _ in
                getNavigationController().popViewController(animated: true)
                self?.didOut()
            })
            .disposed(by: disposeBag)
        
        output.weatherInfoDatas
            .bind { [weak self] infos in
                guard let self = self else { return }
                self.weatherMarkers.forEach { $0.map = nil}
                self.weatherMarkers.removeAll()
                
                infos.forEach {
                    guard let marker = self.getMarker($0) else { return }
                    marker.map = self.mapView
                    self.weatherMarkers.append(marker)
                    log.d("뿅")
                }
                
                if self.weatherMarkers.count == 1 {
                    if let lastMarker = self.weatherMarkers.last {
                        self.mapView.selectedMarker = lastMarker
                        guard let markerData = lastMarker.userData as? WeatherInfo,
                              let localCoordinate = markerData.localCoordinate else { return }
                        let camera = GMSCameraPosition.camera(withLatitude: localCoordinate.latitude,
                                                              longitude: localCoordinate.longitude,
                                                              zoom: self.approximateLocationZoomLevel)
                        self.mapView.animate(to: camera)
                    }
                } else {
                    let coordinate = CLLocationCoordinate2D(latitude: 35.52890210103481, longitude: 127.76420239359139)
                    let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 7)
                    self.mapView.animate(to: camera)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
//        print("[GMSCameraPosition] zoom: \(position.zoom), [coordinate]: (\(position.target.latitude), \(position.target.longitude))")
    }
}
