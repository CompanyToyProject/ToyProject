//
//  CoordinatorFinishDelegate.swift
//  ToyProject
//
//  Created by yeoboya on 2022/09/23.
//

import Foundation

protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(childCoordinator: Coordinator)
}
