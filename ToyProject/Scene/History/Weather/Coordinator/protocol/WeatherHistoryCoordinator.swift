//
//  WeatherHistoryCoordinator.swift
//  ToyProject
//
//  Created by yeoboya on 2022/10/04.
//

import Foundation

protocol WeatherHistoryCoordinator: Coordinator {
    func push(localCoordinator item: LocalCoordinate)
}
