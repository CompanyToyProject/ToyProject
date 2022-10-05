//
//  WeatherInfoHistoryViewController.swift
//  ToyProject
//
//  Created by yeoboya on 2022/10/04.
//

import Foundation
import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class WeatherInfoHistoryViewController: UIViewController {
    var tableView = UITableView()
    var leftBarButton: UIBarButtonItem!
    
    let localData: BehaviorRelay<[LocalCoordinate]> = .init(value: [])
    var disposeBag = DisposeBag()
    
    var viewModel: WeatherInfoHistoryViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setTableView()
        
        bind()
        
        self.viewModel.loadWeatherDatas()
    }
    
    func setNavigationBar() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [ .foregroundColor : UIColor.black]
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        leftBarButton = UIBarButtonItem(image: UIImage(systemName: "arrowshape.turn.up.left.fill"), primaryAction: nil, menu: nil)
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    deinit {
        print("WeatherInfoHistoryViewController deinit...")
    }
}
