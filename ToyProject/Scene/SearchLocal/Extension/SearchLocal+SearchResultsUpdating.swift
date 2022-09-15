//
//  SearchLocal+SearchResultsUpdating.swift
//  TestMap
//
//  Created by yeoboya on 2022/09/13.
//

import Foundation
import UIKit

extension SearchLocalViewControllr: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if isFilltering {
            guard let text = searchController.searchBar.text else { return }
            self.filterArr.onNext(self.arr.filter { $0.localFullString.contains(text)})
        } else {
            self.filterArr.onNext(self.arr)
        }
       
    }
}
