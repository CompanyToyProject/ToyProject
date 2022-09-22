//
//  HistoryRow.swift
//  ToyProject
//
//  Created by yeoboya on 2022/09/22.
//

import Foundation
import UIKit
import SnapKit
import Then

class HistoryRow: UITableViewCell {
    let fcstDateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
    }
    
    let infoLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
    }
    
    let weatherImageView = UIImageView()
    
    func configUI(_ data: Weather) {
        initView()
        
        fcstDateLabel.text = data.date?.toString
        
        guard let pty = data.pty,
              let sky = data.sky,
              let t1h = data.t1h,
              let PTY = PTY_CODE(rawValue: pty),
              let SKY = SKY_CODE(rawValue: sky) else { return }
        
        var stateStr = ""
        if PTY == .none {
            stateStr = SKY.toString
        }
        else {
            stateStr = "\(SKY.toString) / \(PTY.toString)"
        }
        
        infoLabel.text = t1h + "°C, " + stateStr
        
        if PTY == .none {
            weatherImageView.image = SKY.image
        }
        else {
            weatherImageView.image = PTY.image
        }
    }
    
    private func initView() {
        setUI()
        setConstraints()
    }
    
    private func setUI() {
        [
            fcstDateLabel,
            infoLabel,
            weatherImageView
        ].forEach { self.addSubview($0) }
    }
    
    private func setConstraints() {
        fcstDateLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(14)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(fcstDateLabel.snp.bottom).offset(4)
            make.leading.equalTo(fcstDateLabel)
            make.bottom.equalToSuperview().inset(14)
        }
        
        weatherImageView.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.trailing.equalToSuperview().inset(14)
            make.centerY.equalToSuperview()
        }
        
    }
}
