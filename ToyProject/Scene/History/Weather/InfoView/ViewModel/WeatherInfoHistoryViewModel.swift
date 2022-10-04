//
//  WeatherInfoHistoryViewModel.swift
//  ToyProject
//
//  Created by yeoboya on 2022/10/04.
//

import Foundation
import RxSwift
import RxCocoa

class WeatherInfoHistoryViewModel: ViewModelProtocol {
    typealias Dependency = Model
    
    struct Model {
        var weatherDatas: [Weather] = []
    }
    
    struct Input {
        
    }
    
    struct Output {
        var weatherDatas: PublishSubject<[Weather]>
        var titleText: BehaviorSubject<String>
    }
    
    var model: Dependency       = .init()
    var input: Input?
    var output: Output?
    var disposeBag: DisposeBag  = .init()
    
    init(input: Input, localItem: LocalCoordinate) {
        guard let infos = localItem.weatherInfo?.array as? [Weather] else { return }
        self.model.weatherDatas = infos.reversed()
        
        let weatherDatas = PublishSubject<[Weather]>()
        let titleText = BehaviorSubject<String>.init(value: "")
        
        self.input = input
        self.output = Output(weatherDatas: weatherDatas,
                             titleText: titleText)
        
        titleText.onNext(localItem.localFullString)
    }
    
    func loadWeatherDatas() {
        self.output?.weatherDatas.onNext(self.model.weatherDatas)
    }
    
    deinit {
        print("WeatherHistoryViewModel deinit...")
    }
}
