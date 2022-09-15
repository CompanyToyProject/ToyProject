//
//  GlobalFunctions.swift
//  TestMap
//
//  Created by yeoboya on 2022/09/05.
//

import Foundation
import UIKit

// return root view controller
func getNavigationController() -> UINavigationController {
    return UIApplication.shared.windows[0].rootViewController as! UINavigationController
}

// return visible view controller
func getVisibleViewController() -> UIViewController {
    return getNavigationController().visibleViewController!
}

// return top view controller
func getTopViewController() -> UIViewController {
    return getNavigationController().topViewController!
}
