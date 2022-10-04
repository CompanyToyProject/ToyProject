//
//  HistoryTableView.swift
//  ToyProject
//
//  Created by yeoboya on 2022/09/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit
import CoreData

class HistoryTableViewController: NSObject {
    var tableView: UITableView!
    
    var disposeBag = DisposeBag()
    
    var localCoordinate = PublishSubject<LocalCoordinate>.init()
    var arr = BehaviorSubject<[Weather]>.init(value: [])
    
    init(tableView: UITableView) {
        super.init()
        
        self.tableView = tableView
        
        self.bind()
        self.setTableView()
    }
    
    func bind() {
        localCoordinate
            .map({ local -> [Weather] in
                guard let infos = local.weatherInfo?.array as? [Weather] else { return [] }
                
                return infos.reversed()
            })
            .bind(to: arr)
            .disposed(by: disposeBag)
    }
    
    func removeFromSuperView() {
        tableView.animHide(transform: CGAffineTransform(translationX: tableView.frame.width, y: 0)) { _ in
            self.tableView.removeFromSuperview()
        }
    }
    
    deinit {
        print("HistoryTableViewController deinit...")
    }
}

extension HistoryTableViewController: UITableViewDelegate {
    
    func setTableView() {
        self.tableView.allowsSelection = false
        self.tableView.backgroundColor = .white
        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.register(HistoryRow.self, forCellReuseIdentifier: "HistoryRow")
        
        self.tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        arr
            .bind(to: self.tableView.rx.items) { (tableView: UITableView, index:Int, element: Weather) -> UITableViewCell in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryRow") as? HistoryRow else {
                    return UITableViewCell()
                }
                cell.configUI(element)

                return cell
            }
            .disposed(by: disposeBag)
        
        
    }
}
