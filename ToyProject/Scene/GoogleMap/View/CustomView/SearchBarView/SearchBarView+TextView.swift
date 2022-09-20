//
//  SearchBarView+TextView.swift
//  TestMap
//
//  Created by yeoboya on 2022/09/15.
//

import Foundation
import UIKit

extension SearchBarView: UITextViewDelegate {
    
    func endEditing() {
        textView.endEditing(true)
    }
    
    func setTextView() {
        
        self.textView.returnKeyType = .done
        
        self.textView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        self.textView.rx.didBeginEditing
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                if !self.textView.hasText {
                    self.tableViewController?.updateText.onNext((self.textView.text, self.textView.hasText))
                }
            })
            .disposed(by: disposeBag)
        
        self.textView.rx.didEndEditing
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                if self.textView.text.isEmpty {
                    self.placeHolderLabel.isHidden = false
                }
            })
            .disposed(by: disposeBag)
        
        self.textView.rx.didChange
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                if self.textView.text.isEmpty {
                    self.tableViewController?.updateText.onNext((self.textView.text, false))
                }
            })
            .disposed(by: disposeBag)
        
        self.textView.rx.text.orEmpty
            .scan("", accumulator: { [weak self] previous, new -> String in
                guard let self = self else { return "" }
                if new.contains("\n") {
                    if !previous.isEmpty {
                        self.tableViewController?.updateText.onNext((previous, true))
                    }
                    return previous
                }
                return new
            })
            .bind(to: textView.rx.text)
            .disposed(by: disposeBag)
        
        self.textView.rx.text.orEmpty
            .distinctUntilChanged()
            .bind(onNext: { [weak self] text in
                guard let self = self else { return }
                if text.isEmpty {
                    self.tableViewController?.updateText.onNext((text, false))
                    self.placeHolderLabel.isHidden = false
                } else {
                    self.placeHolderLabel.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        
    }
}
