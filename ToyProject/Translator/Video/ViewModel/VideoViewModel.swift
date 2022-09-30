//
//  VideoViewModel.swift
//  ToyProject
//
//  Created by yeoboya-211221-05 on 2022/09/29.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class VideoViewModel {
    
    struct Input {
        let getVideoTap: Observable<Void>
        let playVideoTap: Observable<Void>
        let videoToTextTap: Observable<Void>
    }
    
    struct Output {
        
    }
    
    var output: Output = .init()
    var inputModel: Input?
    var disposeBag = DisposeBag()
    
    init(input: Input) {
        
        
        self.setInput(input: input)
    }
    
    func setInput(input: Input) {
        self.inputModel = input
        
        input.getVideoTap
            .bind{ [unowned self] in
                askPhotoAuthorization {
                    DispatchQueue.main.async {
                        self.openVideoCollectionView()
                    }
                }
            }
            .disposed(by: disposeBag)
        
        input.playVideoTap
            .bind{
                log.d("playVideoTap")
            }
            .disposed(by: disposeBag)
        
        input.videoToTextTap
            .bind{
                log.d("videoToTextTap")
            }
            .disposed(by: disposeBag)
    }
    
    deinit {
        log.d("VideoViewModel deinitdeinitdeinitdeinitdeinitdeinitdeinitdeinit")
    }
}
