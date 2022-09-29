//
//  VideoCollectionView.swift
//  ToyProject
//
//  Created by yeoboya-211221-05 on 2022/09/29.
//

import Foundation
import UIKit
import AVFoundation
import RxSwift
import RxCocoa
import SnapKit
import Then
import Photos

class VideoCollectionView: UIView {
    
    lazy var kingView = UIView().then{
        $0.backgroundColor = .white
    }
    
    lazy var mainView = UIView().then{
        $0.backgroundColor = .clear
    }
    
    lazy var mainStackView = UIStackView().then{
        $0.alignment = .fill
        $0.distribution = .fill
        $0.axis = .vertical
    }
    
    lazy var headerView = UIView().then{
        $0.backgroundColor = .systemPink
    }
    
    lazy var closeBtn = UIButton().then{
        $0.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        $0.setTitle("닫기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .black
    }
    
    lazy var bodyView = UIView().with{
        $0.backgroundColor = .clear
    }
    
    lazy var videoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()).then {
        $0.delegate = self
        $0.dataSource = self
        $0.register(VideoCell.self, forCellWithReuseIdentifier: "VideoCell")
        $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.allowsSelection = true
        $0.isPagingEnabled = false
        $0.backgroundColor = .white
    }
    
    var asset: PHFetchResult<PHAsset>?
    var viewModel: VideoCollectionViewModel!
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        setConstraints()
        firstSetting()
        binding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView(){
        addSubview(kingView)
        
        kingView.addSubview(mainView)
        
        mainView.addSubview(mainStackView)
        
        [headerView, bodyView].forEach{
            mainStackView.addArrangedSubview($0)
        }
        
        headerView.addSubview(closeBtn)
        
        bodyView.addSubview(videoCollectionView)
        
    }
    
    private func setConstraints(){
        kingView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        mainView.snp.makeConstraints{
            $0.edges.equalTo(kingView.safeAreaLayoutGuide)
        }
        
        mainStackView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        headerView.snp.makeConstraints{
            $0.height.equalTo(50)
        }
        
        closeBtn.snp.makeConstraints{
            $0.left.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
        
        videoCollectionView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
    private func firstSetting(){
     
        input()
        output()
    }
    
    private func input(){
        
    }
    
    private func output(){
        
    }
    
    private func binding(){
        closeBtn.rx.tap
            .bind{ [unowned self] in
                self.removeFromSuperview()
            }
            .disposed(by: disposeBag)
    }
    
    deinit {
        log.d("VideoCollectionView deinitdeinitdeinitdeinitdeinitdeinitdeinitdeinit")
    }
}

