//
//  SearchLocalViewController.swift
//  TestMap
//
//  Created by yeoboya on 2022/09/13.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class SearchLocalViewControllr: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var disposeBag = DisposeBag()
    
    var arr = [LocalCoordinate]()
    var filterArr = BehaviorSubject<[LocalCoordinate]>.init(value: [])
    
    var isFilltering: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        let bool = isActive && isSearchBarHasText
        return bool
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupSearchController()
        self.setTableView()
        
    }
    
    func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search Local!!"
        searchController.hidesNavigationBarDuringPresentation = false
        
        searchController.searchResultsUpdater = self
        
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "Search"
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
}
