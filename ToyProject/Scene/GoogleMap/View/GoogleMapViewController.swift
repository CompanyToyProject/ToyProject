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
    var leftBarButton: UIButton!
    var searchBarView: SearchBarView!
    
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var preciseLocationZoomLevel: Float = 15.0
    var approximateLocationZoomLevel: Float = 10.0
    
    var container: NSPersistentContainer!
    
    var keyboardIsHide = true
    
    var weatherMarkers = [GMSMarker]()
    let disposeBag = DisposeBag()
    
    var selectedLocal: LocalCoordinate?
    
    var viewModel: GoogleMapViewModel!
    var weatherInfo: PublishSubject<(WeatherInfo, Bool)>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.container = PersistenceManager.shared.persistentContainer
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingHeading()
        locationManager.delegate = self
        
        setKeyboard()
        setNavigationBar()
        setMapView()
        
        setInput()
        bind()
        
        setSearchBarView()
//        setCoreDataBtn()
        
        let loading = LoadingViewController.shared
        loading.loadingViewSetting(view: self.view, delay: .seconds(2))
        loading.startLoading {
            let predicate = NSPredicate(format: "level1 == %@ && level2 != %@ && level3 == %@", "광주광역시", "", "")
            self.viewModel.getWeatherInfo(predicate: predicate) { info in
                loading.endLoading()
                if info.count < 1 {
                    Toast.show("날씨정보를 불러올 수 없습니다")
                }
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
        self.view.backgroundColor = .white
        self.navigationItem.title = "WeatherMap_TitleText".localized
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [ .foregroundColor : UIColor.black]
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        rightBarButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: nil, action: nil)
        
        leftBarButton = UIButton(type: .system)
        leftBarButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        leftBarButton.setTitle("BACK", for: .normal)
        let leftButton = UIBarButtonItem(customView: leftBarButton)
        self.navigationItem.leftBarButtonItem = leftButton
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



