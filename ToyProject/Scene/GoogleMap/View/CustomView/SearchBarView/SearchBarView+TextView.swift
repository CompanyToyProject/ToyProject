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
        tableViewController?.updateText.onNext((textView.text, textView.hasText))
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            placeHolderLabel.isHidden = false
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            tableViewController?.updateText.onNext((textView.text, false))
        }
    }
    
    func endEditing() {
        textView.endEditing(true)
        textViewDidEndEditing(textView)
    }
}
