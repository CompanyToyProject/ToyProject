//
//  VideoCell.swift
//  ToyProject
//
//  Created by yeoboya-211221-05 on 2022/09/29.
//

import Foundation
import UIKit
import SnapKit
import Then

class VideoCell: UICollectionViewCell {
    
    lazy var mainView = UIView().then{
        $0.backgroundColor = .white
    }
    
    lazy var videoImage = UIImageView().then{
        $0.contentMode = .scaleToFill
    }
    
    lazy var timeLabel = UILabel().then{
        $0.text = "00:00"
        $0.font = UIFont.boldSystemFont(ofSize: 12)
        $0.textColor = .black
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView(){
        addSubview(mainView)
        
        [videoImage, timeLabel].forEach{
            mainView.addSubview($0)
        }
        
        setConstraints()
    }
    
    private func setConstraints(){
        mainView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        videoImage.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints{
            $0.right.bottom.equalToSuperview().inset(10)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.videoImage.image = nil
        self.timeLabel.text = "00:00"
    }
}
