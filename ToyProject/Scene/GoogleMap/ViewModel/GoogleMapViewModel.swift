//
//  GoogleMapViewModel.swift
//  TestMap
//
//  Created by yeoboya on 2022/09/14.
//

import Foundation
import RxSwift
import RxCocoa

class GoogleMapViewModel: ViewModelProtocol {
    typealias Dependency = Model
    
    struct Model {
        
    }
    
    struct Input {
        var weatherInfo: Observable<(WeatherInfo, Bool)>    // 기존에 있던 마커를 지울건지?
    }
    
    struct Output {
        var weatherInfoDatas: BehaviorRelay<[WeatherInfo]>
    }
    
    var model: Dependency       = .init()
    var input: Input?
    var output: Output?
    var disposeBag: DisposeBag  = .init()
    
    init(input: Input) {
        
        let weatherInfoDatas = BehaviorRelay<[WeatherInfo]>(value: [])
        
        input.weatherInfo
            .subscribe { [weak self] info, bool in
                if bool {
                    weatherInfoDatas.accept([info])
                }
                else {
                    var list = weatherInfoDatas.value
                    list.append(info)
                    weatherInfoDatas.accept(list)
                }
            }
            .disposed(by: disposeBag)
        
        output = Output(weatherInfoDatas: weatherInfoDatas)
    }
}
