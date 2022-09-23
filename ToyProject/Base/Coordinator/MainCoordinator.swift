//
//  MainCoordinator.swift
//  ToyProject
//
//  Created by yeoboya on 2022/09/22.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = ViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func pushWeatherMapVC() {
        let storyBoard = UIStoryboard(name: "GoogleMapView", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: "GoogleMapView") as? GoogleMapViewController else {
            return
        }
        navigationController.pushViewController(vc, animated: true)
    }
    
    func pushWeatherHistoryVC() {
        let vc = WeatherHistoryViewController()
        getNavigationController().pushViewController(vc, animated: true)
    }
}
