//
//  GoogleMapView+SearchBar.swift
//  ToyProject
//
//  Created by yeoboya on 2022/09/16.
//

import Foundation
import CoreData
import UIKit

extension GoogleMapViewController {
    func setSearchBarView() {
        searchBarView = SearchBarView()
        
        let request: NSFetchRequest<LocalCoordinate> = LocalCoordinate.fetchRequest()
        let fetchResult = PersistenceManager.shared.fetch(request: request)
        searchBarView.configUI(arr: fetchResult)
        
        self.view.addSubview(searchBarView)
        
        searchBarView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        searchBarView.selectItem
            .bind { [weak self] selectedLocal in
                guard let self = self else { return }
                log.d(selectedLocal.localFullString)
                self.viewModel.getWeatherInfoFromServer(selectedLocal) { [weak self] info in
                    guard let self = self else { return }
                    self.weatherInfo.onNext((info, true))
                }
            }
            .disposed(by: disposeBag)
    }
    
    func hideSearchBar(_ isHidden: Bool = true) {
        if isHidden {
            let transform = CGAffineTransform(translationX: 0, y: -50)
            self.searchBarView.animHide(transform: transform) { _ in
                self.searchBarView.textView.text = ""
                self.navigationItem.rightBarButtonItem = self.rightBarButton
            }
        }
        else {
            self.searchBarView.tableViewZeroHeight()
            self.searchBarView.animShow()
            self.navigationItem.setRightBarButton(nil, animated: true)
        }
            
    }
}
