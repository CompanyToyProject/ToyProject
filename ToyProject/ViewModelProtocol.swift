//
//  ViewModelProtocol.swift
//  TestMap
//
//  Created by yeoboya on 2022/09/14.
//

import Foundation
import RxSwift

protocol ViewModelProtocol {
    associatedtype InputType
    associatedtype OutputType
    associatedtype DependencyModelType
    
    var model: DependencyModelType { get set }
    var input: InputType? { get set }
    var output: OutputType? { get set }
    var disposeBag: DisposeBag { get set }
}
