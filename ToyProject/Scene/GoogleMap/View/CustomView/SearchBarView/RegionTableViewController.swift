//
//  RegionTableView.swift
//  TestMap
//
//  Created by yeoboya on 2022/09/15.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class RegionTableViewController: NSObject {
    var tableView: UITableView!
    
    var disposeBag = DisposeBag()
    
    var arr = [LocalCoordinate]()
    var filterArr = BehaviorSubject<[LocalCoordinate]>.init(value: [])
    
    var updateText = PublishSubject<(String, Bool)>()
    var tableViewHeight = PublishSubject<CGFloat>()
    var selectItem = PublishSubject<LocalCoordinate>()
    
    let rowMaxCount = 4
    let defaultTableRowHeight = 45.0
    
    init(tableView: UITableView) {
        super.init()
        
        self.tableView = tableView
        
        self.bind()
        self.setTableView()
    }
    
    func bind() {
        updateText.bind { [weak self] text, isFilltering in
            guard let self = self else { return }
            if isFilltering {
                let list = self.arr.filter { $0.localFullString.contains(text)}
                if list.count == 0 {
                    Toast.show("검색된 지역이 없습니다.")
                    log.d("검색된 지역이 없습니다.")
                }
                self.filterArr.onNext(list)
                
                if list.count >= self.rowMaxCount {
                    self.tableViewHeight.onNext(Double(self.rowMaxCount) * self.defaultTableRowHeight)
                }
                else {
                    self.tableViewHeight.onNext(Double(list.count) * self.defaultTableRowHeight)
                }
            } else {
                self.filterArr.onNext(self.arr)
                
                if self.arr.count >= 7 {
                    self.tableViewHeight.onNext(Double(self.rowMaxCount) * self.defaultTableRowHeight)
                } else {
                    self.tableViewHeight.onNext(Double(self.arr.count) * self.defaultTableRowHeight)
                }
            }
        }
        .disposed(by: disposeBag)
    }
    
    deinit {
        print("RegionTableViewController deinit...")
    }

}

extension RegionTableViewController: UITableViewDelegate {
    
    func setTableView() {
        self.tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        self.tableView.rx.itemSelected
            .map({ indexPath -> LocalCoordinate? in
                if let list = try? self.filterArr.value() {
                    let selectedLocal = list[indexPath.row]
                    return selectedLocal
                } else {
                    return nil
                }
            })
            .compactMap({ $0  })
            .bind(onNext: { [weak self] in
                guard let self = self else { return }
                self.selectItem.onNext($0)
                self.tableViewHeight.onNext(0)
            })
            .disposed(by: disposeBag)
        
        
        filterArr
            .do(onNext: { _ in
                self.tableView.contentOffset.y = 0
            })
            .bind(to: self.tableView.rx.items) { (tableView: UITableView, index:Int, element: LocalCoordinate) -> UITableViewCell in
                let cell = UITableViewCell()
                cell.textLabel?.text = element.localFullString

                return cell
            }
            .disposed(by: disposeBag)
        
        
    }
}
