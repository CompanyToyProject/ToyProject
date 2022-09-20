//
//  LoadingViewController.swift
//  ToyProject
//
//  Created by yeoboya on 2022/09/20.
//

import Foundation
import RxSwift

class LoadingViewController {
    static var shared: LoadingViewController = LoadingViewController()
    
    let loadingView = LoadingView()
    
    var delay: DispatchTimeInterval!
    
    var loadingDelay: PublishSubject<Void>!
    var disposeBag = DisposeBag()
    
    func loadingViewSetting(view: UIView, delay: DispatchTimeInterval = .seconds(1)) {
        self.delay = delay
        loadingView.frame = view.bounds
        loadingView.isHidden = true
        view.addSubview(loadingView)
    }
    
    func startLoading(completionHandler: @escaping () -> Void) {
        print("ASB >> startLoading")
        
        self.loadingDelay = PublishSubject<Void>()
        
        loadingDelay
            .observeOn(MainScheduler.asyncInstance)
            .timeout(delay, scheduler: MainScheduler.instance)
            .subscribe { _ in
                print("ASB >> 정상")
                self.loadingDelay.onCompleted()
            } onError: { _ in
                print("ASB >> TimeOut!!!")
                self.loadingView.startLoading()
            } onCompleted: {
                print("ASB >> onCompleted")
            }
            onDisposed: {
                print("ASB >> onDisposed")
            }
            .disposed(by: disposeBag)
        
        completionHandler()
    }
    
    func endLoading() {
        print("ASB >> endLoading()")
        loadingDelay.onNext(())
        loadingView.removeLoading()
    }
}
