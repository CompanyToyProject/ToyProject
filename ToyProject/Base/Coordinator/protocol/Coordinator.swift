//
//  Coordinator.swift
//  ToyProject
//
//  Created by yeoboya on 2022/09/22.
//

import Foundation
import UIKit

protocol Coordinator: class {
    var finishDelegate: CoordinatorFinishDelegate? { get set }
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
    func finish()
}

extension Coordinator {
    func finish() {
        childCoordinators.removeAll()
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}
