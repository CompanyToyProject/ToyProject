//
//  GlobalFunc.swift
//  ToyProject
//
//  Created by yeoboya-211221-05 on 2022/09/21.
//

import Foundation
import UIKit

// confirm 창.
func myConfirm(title: String, message: String, cancelLabel: String, okLabel: String, cancelPressed: (()->Void)?, okPressed: (()->Void)?) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: cancelLabel, style: .default, handler: {(action) in
        if let cancelCallback = cancelPressed {
            cancelCallback()
        }
    })
    let okAction = UIAlertAction(title: okLabel, style: .default, handler: {(action) in
        if let okCallback = okPressed {
            okCallback()
        }
    })
    alertController.addAction(cancelAction)
    alertController.addAction(okAction)
    getVisibleViewController().present(alertController, animated: false, completion: nil)
}
