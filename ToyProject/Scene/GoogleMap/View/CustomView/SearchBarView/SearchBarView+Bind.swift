//
//  SearchBarView+Bind.swift
//  ToyProject
//
//  Created by yeoboya on 2022/09/16.
//

import Foundation
import RxSwift
import RxCocoa

extension SearchBarView {
    func bind() {
        tableViewController?.tableViewHeight
            .distinctUntilChanged()
            .bind(onNext: { [weak self] height in
                self?.tableView.snp.updateConstraints { make in
                    make.height.equalTo(height)
                    make.bottom.equalToSuperview().inset(10)
                }
            })
            .disposed(by: disposeBag)
        
        tableViewController?.selectItem
            .bind(onNext: { [weak self] localCoordinate in
                guard let self = self else { return }
                if let _  = localCoordinate.level1,
                   localCoordinate.level1!.contains("검색된 지역이 없습니다.") {
                    self.textView.text = ""
                } else {
                    self.selectItem.onNext(localCoordinate)
                }
                self.endEditing()
            })
            .disposed(by: disposeBag)
        
        searchBtn.rx.tap
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.tableViewController?.updateText.onNext((self.textView.text, self.textView.hasText))
                self.endEditing()
            })
            .disposed(by: disposeBag)
    }
}
