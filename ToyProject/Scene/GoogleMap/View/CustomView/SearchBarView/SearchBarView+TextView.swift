//
//  SearchBarView+TextView.swift
//  TestMap
//
//  Created by yeoboya on 2022/09/15.
//

import Foundation
import UIKit

extension SearchBarView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeHolderLabel.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            placeHolderLabel.isHidden = false
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let isActive = textView.isFocused
        let hasText = textView.text.isEmpty == false
        let isFilltering = isActive && hasText
        
        tableViewController?.updateText.onNext((textView.text, isFilltering))
    }
    
    func endEditing() {
        textView.endEditing(true)
    }
}
