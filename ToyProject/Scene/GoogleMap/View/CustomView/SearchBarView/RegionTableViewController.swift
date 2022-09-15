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
                self.filterArr.onNext(self.arr.filter { $0.localFullString.contains(text)})
            } else {
                self.filterArr.onNext(self.arr)
            }
        }
    }

}

extension RegionTableViewController: UITableViewDelegate {
    func setTableView() {
        self.tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        self.tableView.rx.itemSelected
            .bind { [weak self] indexPath in
                guard let self = self else { return }
                if let list = try? self.filterArr.value() {
                    let selectedLocal = list[indexPath.row]
                    
                    getNavigationController().popViewController(animated: true)
                    guard let vc = getVisibleViewController() as? GoogleMapViewController else {
                         return
                    }
                    vc.selectedLocal = selectedLocal
                }
            }
            .disposed(by: disposeBag)
        
        filterArr
            .bind(to: self.tableView.rx.items) { (tableView: UITableView, index:Int, element: LocalCoordinate) -> UITableViewCell in
                let cell = UITableViewCell()
                cell.textLabel?.text = element.localFullString

                return cell
            }
            .disposed(by: disposeBag)
        
    }
}
