//
//  VideoCollectionViewModel.swift
//  ToyProject
//
//  Created by yeoboya-211221-05 on 2022/09/29.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class VideoCollectionViewModel {
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    var inputModel: Input?
    var output: Output = .init()
    var model = VideoCollectionModel()
    var disposeBag = DisposeBag()
    
    init(input: Input) {
        
        self.setInputs(input: input)
    }
    
    func setInputs(input: Input) {
        self.inputModel = input
        
    }
    
    deinit {
        log.d("VideoCollectionViewModel deinitdeinitdeinitdeinitdeinitdeinitdeinitdeinit")
    }
}
