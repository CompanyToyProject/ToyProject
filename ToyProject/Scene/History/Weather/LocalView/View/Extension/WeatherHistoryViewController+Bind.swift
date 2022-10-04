//
//  WeatherHistoryViewController+Bind.swift
//  ToyProject
//
//  Created by yeoboya on 2022/09/22.
//

import Foundation
import RxSwift
import RxCocoa

extension WeatherHistoryViewController {
    func setInput() {
        let input = WeatherHistoryViewModel.Input(selectIndex: tableView.rx.itemSelected.asObservable())
        
        viewModel = WeatherHistoryViewModel(input: input)
    }
    
    func bind() {
        guard let output = viewModel.output else {
            return
        }
        
        output.localDatas
            .bind(to: self.tableView.rx.items) { (tableView: UITableView, index:Int, element: LocalCoordinate) -> UITableViewCell in
                let cell = UITableViewCell()
                cell.textLabel?.text = element.localFullString
                cell.selectionStyle = .none
                cell.backgroundColor = .white
                cell.textLabel?.textColor = .black
                return cell
            }
            .disposed(by: disposeBag)
        
        output.selectItem
            .bind(onNext: { [weak self] item in
                guard let self = self else { return }
                
                self.coordinator?.push(localCoordinator: item)
            })
            .disposed(by: disposeBag)
        
        leftBarButton.rx.tap
            .bind(onNext: {
                getNavigationController().popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
