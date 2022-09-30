//
//  GlobalFunc.swift
//  ToyProject
//
//  Created by yeoboya-211221-05 on 2022/09/21.
//

import Foundation
import UIKit
import Photos

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

func askPhotoAuthorization(callBack: @escaping () -> Void) {
    PHPhotoLibrary.requestAuthorization { (status) -> Void in
        switch status {
        case .authorized:
            callBack()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (status) -> Void in
                if status == .authorized {
                    callBack()
                }
            }
        case .restricted, .limited:
            return
        case .denied:
            myConfirm(title: "사진 라이브러리 사용권한 설정이 필요합니다", message: "설정을 변경하시겠습니까?", cancelLabel: "취소", okLabel: "확인", cancelPressed: nil, okPressed: {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            })
        @unknown default:
            return
        }
    }
}
