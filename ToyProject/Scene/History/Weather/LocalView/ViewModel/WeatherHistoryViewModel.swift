//
//  WeatherHistoryViewModel.swift
//  ToyProject
//
//  Created by yeoboya on 2022/09/22.
//

import Foundation
import RxSwift
import RxCocoa
import CoreData

class WeatherHistoryViewModel: ViewModelProtocol {
    typealias Dependency = Model
    
    struct Model {
        var localDatas: [LocalCoordinate] = []
    }
    
    struct Input {
        var selectIndex: Observable<IndexPath>
    }
    
    struct Output {
        var localDatas: PublishSubject<[LocalCoordinate]>
        var selectItem: PublishSubject<LocalCoordinate>
    }
    
    var model: Dependency       = .init()
    var input: Input?
    var output: Output?
    var disposeBag: DisposeBag  = .init()
    
    init(input: Input) {
        let localDatas = PublishSubject<[LocalCoordinate]>()
        let selectItem = PublishSubject<LocalCoordinate>()
        
        input.selectIndex
            .map({ indexPath -> LocalCoordinate in
                return self.model.localDatas[indexPath.row]
            })
            .bind(to: selectItem)
            .disposed(by: disposeBag)
        
        self.input = input
        self.output = Output(localDatas: localDatas,
                             selectItem: selectItem)
    }
    
    func loadHasHistoryData() {
        let request : NSFetchRequest<LocalCoordinate> = LocalCoordinate.fetchRequest()
        let predicate = NSPredicate(format: "NONE weatherInfo == nil")
        request.predicate = predicate
        let fetchRes = PersistenceManager.shared.fetch(request: request)
        
        model.localDatas = fetchRes
        output?.localDatas.onNext(fetchRes)
    }
    
    deinit {
        print("WeatherHistoryViewModel deinit...")
    }
}
