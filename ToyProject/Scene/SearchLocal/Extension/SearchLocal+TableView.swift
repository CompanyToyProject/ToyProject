//
//  SearchLocal+TableView.swift
//  TestMap
//
//  Created by yeoboya on 2022/09/13.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension SearchLocalViewControllr: UITableViewDelegate {
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
