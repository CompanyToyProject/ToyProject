//
//  ViewController+Bind.swift
//  ToyProject
//
//  Created by yeoboya on 2022/09/22.
//

import Foundation
import RxSwift
import RxCocoa
import SnapKit

extension ViewController {
    func bind() {
        
        weatherMapBtn.rx.tap
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.getLocalCoordinateDataFromXlsx {
                    DispatchQueue.main.async {
                        self.coordinator?.pushWeatherMapVC()
                    }
                }
            })
            .disposed(by: disposeBag)
        
        weatherHistoryBtn.rx.tap
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .bind(onNext: { _ in
                self.coordinator?.pushWeatherHistoryVC()
            })
            .disposed(by: disposeBag)
        
        translateBtn.rx.tap
            .bind{ [unowned self] in
                let view = TranslatorView(frame: .zero)
                self.view.addSubview(view)
                view.snp.makeConstraints{
                    $0.edges.equalToSuperview()
                }
            }
            .disposed(by: disposeBag)
    }
}
