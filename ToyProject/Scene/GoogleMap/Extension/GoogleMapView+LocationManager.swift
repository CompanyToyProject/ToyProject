//
//  GoogleMapView+LocationManager.swift
//  TestMap
//
//  Created by yeoboya on 2022/09/06.
//

import Foundation
import GooglePlaces
import GoogleMaps

extension GoogleMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        let zoomLevel = locationManager.accuracyAuthorization == .fullAccuracy ? preciseLocationZoomLevel : approximateLocationZoomLevel
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let accuracy = manager.accuracyAuthorization
        
        switch accuracy {
        case .fullAccuracy:
            log.d("Location accuracy is precise.")
        case .reducedAccuracy:
            log.d("Location accuracy is not precise")
        default:
            fatalError()
        }
        
        let status = manager.authorizationStatus
        switch status {
        case .notDetermined:
            log.d("Location status not determined")
        case .denied:
            log.d("User denied access to location")
        case .authorized:
            log.d("Location status is OK")
        default:
            log.d("Status: \(status)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        log.d("Error: \(error)")
    }
}
