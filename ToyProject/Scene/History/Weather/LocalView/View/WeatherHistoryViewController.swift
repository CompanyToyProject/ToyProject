//
//  WeatherHistoryViewController.swift
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

class WeatherHistoryViewController: UIViewController, UITableViewDelegate {
    
    var coordinator: WeatherHistoryCoordinator?
    
    var tableView = UITableView()
    var leftBarButton: UIBarButtonItem!
    
    let localData: BehaviorRelay<[LocalCoordinate]> = .init(value: [])
    var disposeBag = DisposeBag()
    
    var viewModel: WeatherHistoryViewModel!
    
    var tableViewController: HistoryTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setTableView()
        
        setInput()
        bind()
        viewModel.loadHasHistoryData()
    }
    
    func setNavigationBar() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [ .foregroundColor : UIColor.black]
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationItem.title = "WeatherHistory_TitleText".localized
        
        leftBarButton = UIBarButtonItem(image: UIImage(systemName: "arrowshape.turn.up.left.fill"), primaryAction: nil, menu: nil)
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    func setTableView() {
        tableView.backgroundColor = .white
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    deinit {
        print("WeatherHisytoryViewController deinit...")
    }
}
