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
                return cell
            }
            .disposed(by: disposeBag)
        
        output.selectItem
            .bind(onNext: { [weak self] item in
                guard let self = self else { return }
                
                self.navigationItem.title = item.localFullString
                
                let logTableView = UITableView()
                logTableView.alpha = 0
                logTableView.transform = CGAffineTransform(translationX: self.view.frame.width, y: 0)
                self.view.addSubview(logTableView)
                logTableView.snp.makeConstraints { make in
                    make.edges.equalTo(self.tableView)
                }
                self.tableViewController = HistoryTableViewController(tableView: logTableView)
                self.tableViewController.localCoordinate.onNext(item)
                
                logTableView.animShow()
            })
            .disposed(by: disposeBag)
        
        leftBarButton.rx.tap
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .withLatestFrom(output.isShowingDetailView)
            .bind { [weak self] isShowingDetailView in
                guard let self = self else { return }
                if isShowingDetailView {
                    self.navigationItem.title = "MAIN"
                    self.tableViewController.removeFromSuperView()
                    self.tableViewController = nil
                    output.isShowingDetailView.accept(false)
                }
                else {
                    getNavigationController().popViewController(animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
}
