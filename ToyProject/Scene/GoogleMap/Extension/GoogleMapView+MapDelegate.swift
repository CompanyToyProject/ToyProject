//
//  GoogleMapView+MapDelegate.swift
//  TestMap
//
//  Created by yeoboya on 2022/09/06.
//

import Foundation
import GoogleMaps

extension GoogleMapViewController: GMSMapViewDelegate {
    
    // 지도 터치 시
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        log.d("You tapped at: \(coordinate.latitude), \(coordinate.longitude)")
        
        self.touchEmptyMap()
    }
    
    // 마커 터치
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        log.d("You tapped marker is \(marker.title)")
        return false
        // true - 기본 동작 실행 X, fasle: - 기본 동작 실행 O, 기본 동작 - 마커 정보 표시
    }
    
    // 특정 좌표에서 길게 누르면
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        log.d("You Loooooooong Tap at: \(coordinate.latitude), \(coordinate.longitude)")
    }
    
    // 마커가 선택되려고 호출
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        log.d("marker Info Window!!!!! -> [\(marker.title)]")

        guard let info = marker.userData as? WeatherInfo else {
            return UIView()
        }
        let infoView = WeatherMarkerInfoView()
        infoView.frame.size = CGSize(width: 100, height: 100)
            infoView.configView(info)

        return infoView
    }
    
    // 마커의 정보창을 길게 누른 경우
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        log.d("You Loooooooong Tap Marker is \(marker.title)")
    }
    
    // 관심장소를 탭했을때 placeID를 제공
    func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String, name: String, location: CLLocationCoordinate2D) {
        print("You tapped: name - \(name)\nplaceID - \(placeID)\n(lat:lng) - (\(location.latitude):\(location.longitude))")
        
        self.touchEmptyMap()
    }
}
