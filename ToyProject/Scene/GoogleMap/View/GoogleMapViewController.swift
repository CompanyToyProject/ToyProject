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
    var searchBarView: SearchBarView!
    
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var preciseLocationZoomLevel: Float = 15.0
    var approximateLocationZoomLevel: Float = 10.0
    
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
        
        setMapView()
        setNavigationBar()
        
        self.container = PersistenceManager.shared.persistentContainer
        getLocalCoordinateDataFromXlsx()
        
        setInput()
        bind()
        
        let predicate = NSPredicate(format: "level1 == %@ && level2 != %@ && level3 == %@", "광주광역시", "", "")
        self.viewModel.getWeatherInfo(predicate: predicate) { info in
            log.d("info.count: \(info.count)")
        }
        
        setSearchBarView()
        setTapGesture()
    }
    
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
    }
    
    func setTapGesture() {
        self.view.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                self?.searchBarView.endEditing()
            }
            .disposed(by: disposeBag)
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
    
    func setNavigationBar() {
        navigationItem.title = "GoogleMap"
        rightBarButton = UIBarButtonItem(title: "Get Local", style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
}



