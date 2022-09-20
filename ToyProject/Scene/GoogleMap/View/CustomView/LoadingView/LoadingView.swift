//
//  LoadingView.swift
//  ToyProject
//
//  Created by yeoboya on 2022/09/20.
//

import Foundation
import UIKit
import SnapKit
import Then

class LoadingView: UIView {
    var dimView = UIView().then {
        $0.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
    }
    
    var indicator = UIActivityIndicatorView(style: .whiteLarge)
    
    required init() {
        super.init(frame: .zero)
        initView()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        setUI()
        setConstraints()
    }
    
    func startLoading() {
        indicator.startAnimating()
        self.isHidden = false
    }
    
    func removeLoading() {
        indicator.stopAnimating()
        self.removeFromSuperview()
    }
    
    private func setUI() {
        self.isHidden = true
        
        self.addSubview(dimView)
        
        dimView.addSubview(indicator)
    }
    
    private func setConstraints() {
        dimView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        indicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(50)
        }
    }
    
}

