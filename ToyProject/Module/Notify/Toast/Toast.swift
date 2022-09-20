//
//  File.swift
//  ToyProject
//
//  Created by yeoboya on 2022/09/20.
//

import Foundation
import Toast_Swift

public class Toast: NotifyDelgate {
    
    class func show(_ message: String, duration: Double = 3.0, position: ToastPosition = .center, title: String? = nil, image: UIImage? = nil, completion: ((Bool) -> Void)? = nil) {
        var style = ToastStyle()
        style.backgroundColor = .black
        style.messageFont = .systemFont(ofSize: 12)
        style.verticalPadding = 12
        style.horizontalPadding = 16
        style.cornerRadius = 5
        style.shadowOpacity = 0.15
        style.shadowOffset = CGSize(width: 0, height: 3)
        style.shadowColor = .black
        style.titleAlignment = .center
        style.messageAlignment = .center
        style.horizontalPadding = 20
        style.maxWidthPercentage = 0.9
        self.viewController?.view.makeToast(message, duration: duration, position: position, title: title, image: image, style: style, completion: completion)
    }
}
