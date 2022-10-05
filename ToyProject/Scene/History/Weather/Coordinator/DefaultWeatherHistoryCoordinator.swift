//
//  DefaultWeatherHistoryCoordinator.swift
//  ToyProject
//
//  Created by yeoboya on 2022/10/04.
//

import Foundation
import UIKit

class DefaultWeatherHistoryCoordinator: WeatherHistoryCoordinator {
    
    var finishDelegate: CoordinatorFinishDelegate?
    
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = WeatherHistoryViewController()
        vc.coordinator = self
        getNavigationController().pushViewController(vc, animated: true)
    }
    
    func push(localCoordinator item: LocalCoordinate) {
        let vc = WeatherInfoHistoryViewController()
        vc.viewModel = WeatherInfoHistoryViewModel(input: WeatherInfoHistoryViewModel.Input(), localItem: item)
        getNavigationController().pushViewController(vc, animated: true)
    }
    
    func finish() {
        self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}
