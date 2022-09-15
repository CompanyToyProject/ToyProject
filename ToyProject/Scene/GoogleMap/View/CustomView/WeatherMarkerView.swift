//
//  WeatherMarkerView.swift
//  TestMap
//
//  Created by yeoboya on 2022/09/08.
//

import Foundation
import UIKit
import Then
import SnapKit
import SwiftyJSON

class WeatherMarkerView: UIView {
    var bgView = UIView().then {
        $0.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.9)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.cornerRadius = 8
    }
    
    var iconImageView = UIImageView()
    
    required init() {
        super.init(frame: .zero)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        setUI()
        setConstraints()
    }
    
    func configView(_ data: WeatherInfo) {
        iconImageView.image = data.image
    }
    
    private func setUI() {
        self.addSubview(bgView)
        bgView.addSubview(iconImageView)
    }
    
    private func setConstraints() {
        bgView.snp.makeConstraints { make in
            make.width.height.equalTo(45)
            make.center.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(35)
            make.center.equalToSuperview()
        }
    }
}
