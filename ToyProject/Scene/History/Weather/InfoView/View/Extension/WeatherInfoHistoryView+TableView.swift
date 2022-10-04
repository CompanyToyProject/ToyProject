//
//  WeatherInfoHistoryView+TableView.swift
//  ToyProject
//
//  Created by yeoboya on 2022/10/04.
//

import Foundation
import UIKit

extension WeatherInfoHistoryViewController: UITableViewDelegate {
    func setTableView() {
        self.tableView.backgroundColor = .white
        self.tableView.allowsSelection = false
        self.tableView.backgroundColor = .white
        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.register(HistoryRow.self, forCellReuseIdentifier: "HistoryRow")
        
        self.view.addSubview(tableView)
        
        self.tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
}
