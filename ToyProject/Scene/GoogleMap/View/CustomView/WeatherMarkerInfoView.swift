//
//  WeatherMarkerInfoView.swift
//  TestMap
//
//  Created by yeoboya on 2022/09/08.
//

import Foundation
import UIKit
import Then
import SnapKit
import SwiftyJSON

class WeatherMarkerInfoView: UIView {
    let radiusValue: CGFloat = 8
    
    var bgView = UIView().then {
        $0.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.9)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.cornerRadius = 8
    }
    
    var titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .boldSystemFont(ofSize: 10)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    var tempLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 28)
    }
    
    var footerLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.textColor = .lightGray
        $0.font = .systemFont(ofSize: 8)
        $0.lineBreakMode = .byWordWrapping
        $0.textAlignment = .center
    }
    
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
        guard let localCoord = data.localCoordinate else { return }
        titleLabel.text = localCoord.localFullString.isEmpty ? data.localCoordinate?.level1 : localCoord.localFullString
        tempLabel.text = data.tempString
        
        if data.PTY == .none {
            footerLabel.text = data.SKY.toString
        }
        else {
            footerLabel.text = "\(data.SKY.toString) / \(data.PTY.toString)"
        }
    }
    
    private func setUI() {
        
        [
            titleLabel,
            tempLabel,
            footerLabel
        ].forEach { bgView.addSubview($0) }
        
        self.addSubview(bgView)
    }
    
    private func setConstraints() {
        bgView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(radiusValue)
            make.top.equalToSuperview().inset(radiusValue)
        }
        
        tempLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.bottom.equalTo(footerLabel.snp.top).offset(4)
            make.centerX.equalToSuperview()
        }
        
        footerLabel.snp.makeConstraints { make in
            make.width.equalTo(titleLabel)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(radiusValue)
        }
        
    }
}
