//
//  WeatherInfoHistoryView+Bind.swift
//  ToyProject
//
//  Created by yeoboya on 2022/10/04.
//

import Foundation
import RxSwift
import RxCocoa

extension WeatherInfoHistoryViewController {
    
    func bind() {
        guard let output = viewModel.output else {
            return
        }
        
        output.weatherDatas
            .bind(to: self.tableView.rx.items) { (tableView: UITableView, index:Int, element: Weather) -> UITableViewCell in
                let cell = UITableViewCell()
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryRow") as? HistoryRow else {
                    return UITableViewCell()
                }
                cell.configUI(element)

                return cell
            }
            .disposed(by: disposeBag)
        
        output.titleText
            .bind(onNext: { [weak self] title in
                self?.navigationItem.title = title
            })
            .disposed(by: disposeBag)
        
        leftBarButton.rx.tap
            .bind(onNext: {
                getNavigationController().popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
