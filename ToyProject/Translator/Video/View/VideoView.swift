//
//  VideoToText.swift
//  ToyProject
//
//  Created by yeoboya-211221-05 on 2022/09/29.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import AVFoundation
import SnapKit
import Then

class VideoView: UIView {
    
    lazy var kingView = UIView().then{
        $0.backgroundColor = .clear
    }
    
    lazy var mainView = UIView().then{
        $0.backgroundColor = .clear
    }
    
    lazy var mainStackView = UIStackView().then{
        $0.spacing = 0
        $0.alignment = . fill
        $0.distribution = .fill
        $0.axis = .vertical
    }
    
    lazy var headerView = UIView().then{
        $0.backgroundColor = .systemPink
    }
    
    lazy var closeBtn = UIButton().then{
        $0.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("닫기", for: .normal)
        $0.backgroundColor = .black
    }
    
    lazy var videoToTextBtn = UIButton().then{
        $0.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("비디오 텍스트 변경", for: .normal)
        $0.backgroundColor = .black
    }
    
    lazy var bodyView = UIView().then{
        $0.backgroundColor = .blue
    }
    
    lazy var bodyStackView = UIStackView().then{
        $0.alignment = .fill
        $0.distribution = .fill
        $0.axis = .vertical
    }
    
    lazy var videoPlayerView = UIView().then{
        $0.backgroundColor = .red
    }
    
    lazy var textContainerView = UIView().then{
        $0.backgroundColor = .white
    }
    lazy var textView = UITextView().then{
        $0.font = UIFont.boldSystemFont(ofSize: 16)
        $0.textAlignment = .left
        $0.text = "변환된 텍스트가 여기에 나옵니다 변환된 텍스트가 여기에 나옵니다 변환된 텍스트가 여기에 나옵니다 변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다변환된 텍스트가 여기에 나옵니다"
        $0.backgroundColor = .gray
        $0.textColor = .black
    }
    
    lazy var bottomView = UIView().then{
        $0.backgroundColor = .orange
    }
    
    lazy var bottomBtnStackView = UIStackView().then{
        $0.spacing = 10
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.axis = .horizontal
    }
    
    lazy var getVideoBtn = UIButton().then{
        $0.setTitle("비디오 가져오기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .black
    }
    
    lazy var playVideoBtn = UIButton().then{
        $0.setTitle("비디오 재생하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .black
    }
    
    var disposeBag = DisposeBag()
    var viewModel: VideoViewModel!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setView()
        setConstraints()
        firstSetting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView(){
        addSubview(kingView)
        
        kingView.addSubview(mainView)
        
        mainView.addSubview(mainStackView)
        
        [headerView, bodyView, bottomView].forEach{
            mainStackView.addArrangedSubview($0)
        }
        
        [closeBtn, videoToTextBtn].forEach{
            headerView.addSubview($0)
        }
        
        bodyView.addSubview(bodyStackView)
        
        [videoPlayerView, textContainerView].forEach{
            bodyStackView.addArrangedSubview($0)
        }
        
        textContainerView.addSubview(textView)
        
        bottomView.addSubview(bottomBtnStackView)
        
        [getVideoBtn, playVideoBtn].forEach {
            bottomBtnStackView.addArrangedSubview($0)
        }
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
        
        videoToTextBtn.snp.makeConstraints{
            $0.right.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
        
        bodyStackView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        videoPlayerView.snp.makeConstraints{
            $0.height.equalToSuperview().multipliedBy(0.7)
        }
        
        textContainerView.snp.makeConstraints{
            $0.height.equalToSuperview().multipliedBy(0.3)
        }
        
        textView.snp.makeConstraints{
            $0.edges.equalToSuperview().inset(10)
        }
        
        bottomView.snp.makeConstraints{
            $0.height.equalTo(50)
        }
        
        bottomBtnStackView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        
    }
    
    private func firstSetting(){
        getNavigationController().isNavigationBarHidden = true
        textView.isEditable = false
        input()
        output()
        bidning()
    }
    
    private func input(){
        let inputs = VideoViewModel.Input(getVideoTap: getVideoBtn.rx.tap.asObservable(), playVideoTap: playVideoBtn.rx.tap.asObservable(), videoToTextTap: videoToTextBtn.rx.tap.asObservable())
        
        self.viewModel = VideoViewModel(input: inputs)
    }
    
    private func output(){
        
    }
    
    private func bidning(){
        closeBtn.rx.tap
            .bind{ [unowned self] in
                self.removeFromSuperview()
            }
            .disposed(by: disposeBag)
    }
    
    deinit {
        log.d("VideoView deinitdeinitdeinitdeinitdeinitdeinitdeinitdeinit")
    }
    
}
