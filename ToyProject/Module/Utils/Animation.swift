//
//  Animation.swift
//  ToyProject
//
//  Created by yeoboya on 2022/09/16.
//

import Foundation
import UIKit

extension UIView {
    func animShow(_ duration: TimeInterval = 0.35, completion: ((Bool) ->Void)? = nil) {
        UIView.animate(withDuration: duration, delay: 0, options: [.transitionCurlUp], animations: {
            self.alpha = 1
            self.transform = .identity
        }, completion: { _ in
            self.isHidden = false
        })
    }
    
    func animHide(_ duration: TimeInterval = 0.35, completion: ((Bool) ->Void)? = nil) {
        UIView.animate(withDuration: duration, delay: 0, options: [.transitionCurlUp], animations: {
            self.alpha = 0
        }, completion: { _ in
            self.isHidden = true
            completion?(true)
        })
    }
    
    func animHide(_ duration: TimeInterval = 0.35, transform: CGAffineTransform, completion: ((Bool) ->Void)? = nil) {
        UIView.animate(withDuration: duration, delay: 0, options: [.transitionCurlUp], animations: {
            self.alpha = 0
            self.transform = transform
        }, completion: { _ in
            self.isHidden = false
            completion?(true)
        })
    }
}
