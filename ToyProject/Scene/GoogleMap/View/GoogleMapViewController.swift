//
//  GoogleMapViewController.swift
//  TestMap
//
//  Created by yeoboya on 2022/09/05.
//

import Foundation

import UIKit
import GoogleMaps
import GooglePlaces
import CoreData
import RxSwift
import RxCocoa
import RxGesture

class GoogleMapViewController: UIViewController {
    @IBOutlet weak var mapViewContainer: UIView!
    var rightBarButton: UIBarButtonItem!
    var leftBarButton: UIBarButtonItem!
    var searchBarView: SearchBarView!
    
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var preciseLocationZoomLevel: Float = 15.0
    var approximateLocationZoomLevel: Float = 10.0
    
    var keyboardIsHide = true
    
    var weatherMarkers = [GMSMarker]()
    let disposeBag = DisposeBag()
    
    var selectedLocal: LocalCoordinate?
    
    var container: NSPersistentContainer!
    
    var viewModel: GoogleMapViewModel!
    var weatherInfo: PublishSubject<(WeatherInfo, Bool)>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingHeading()
        locationManager.delegate = self
        
        setKeyboard()
        setNavigationBar()
        setMapView()
        
        self.container = PersistenceManager.shared.persistentContainer
        getLocalCoordinateDataFromXlsx()
        
        setInput()
        bind()
        
        let predicate = NSPredicate(format: "level1 == %@ && level2 != %@ && level3 == %@", "광주광역시", "", "")
        self.viewModel.getWeatherInfo(predicate: predicate) { info in
            log.d("info.count: \(info.count)")
        }
        
        setSearchBarView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let selectedLocal = selectedLocal {
            log.d(selectedLocal.toString())
            self.viewModel.getWeatherInfoFromServer(selectedLocal) { [weak self] info in
                guard let self = self else { return }
                self.weatherInfo.onNext((info, true))
            }
        }
    }
    
    func setInput() {
        weatherInfo = PublishSubject<(WeatherInfo, Bool)>()
        
        let input = GoogleMapViewModel.Input(weatherInfo: weatherInfo.asObservable())
        
        self.viewModel = GoogleMapViewModel(input: input)
    }
    
    func setMapView() {
        let camera = GMSCameraPosition.camera(
            withLatitude: 35.146991666666665,
            longitude: 126.84517777777778,
            zoom: 14)
        mapView = GMSMapView.map(withFrame: mapViewContainer.bounds, camera: camera)
        mapView.delegate = self
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        
        let edgeInsets = UIEdgeInsets(top: 80, left: 0, bottom: 0, right: 0)
        mapView.padding = edgeInsets
        
        mapView.settings.myLocationButton = true
        
        mapViewContainer.addSubview(mapView)
    }
    
    func setNavigationBar() {
        navigationItem.title = "GoogleMap"
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        rightBarButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: nil, action: nil)
        
        leftBarButton = UIBarButtonItem(title: "BACK", style: .plain, target: nil, action: nil)
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    func didOut() {
        mapView.clear()
        mapView.removeFromSuperview()
    }
    
    deinit {
        searchBarView.disposeBag = DisposeBag()
        print("GoogleMapViewController deinit...")
    }
}



