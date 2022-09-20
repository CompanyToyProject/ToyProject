//
//  NotifyDelegate.swift
//  ToyProject
//
//  Created by yeoboya on 2022/09/20.
//

import Foundation
import UIKit

protocol NotifyDelgate {
    static var viewController: UIViewController? { get }
    static var navigationController: UINavigationController? { get }
}

extension NotifyDelgate {
    static var viewController: UIViewController? {
        return getVisibleViewController()
    }
    
    static var navigationController: UINavigationController? {
        return getNavigationController()
    }
}
