//
//  GoogleMapView+Keyboard.swift
//  ToyProject
//
//  Created by yeoboya on 2022/09/16.
//

import Foundation
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

extension GoogleMapViewController {
    
    func touchEmptyMap() {
        if self.keyboardIsHide {
            self.hideSearchBar()
        }
        self.searchBarView.endEditing()
    }
    
    func setKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
                
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardShow(_ notification: NSNotification) {
        self.keyboardIsHide = false
    }
    
    @objc func keyboardHide(_ notification: NSNotification) {
        self.keyboardIsHide = true
    }
}
