//
//  ViewController.swift
//  ToyProject
//
//  Created by yeoboya on 2022/09/15.
//

import UIKit
import GoogleMaps
import GooglePlaces
import RxSwift
import SnapKit
import Then

class ViewController: UIViewController {
    
    @IBOutlet weak var googleMapBtn: UIButton!
    
    lazy var btnStackView = UIStackView().then{
        $0.spacing = 10
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.axis = .vertical
    }
    
    lazy var goTranslator = UIButton().then{
        $0.setTitle("번역기", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        $0.backgroundColor = .blue
    }
    
    lazy var goAudioView = UIButton().then{
        $0.setTitle("오디오", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        $0.backgroundColor = .blue
    }
    
    lazy var goVideoView = UIButton().then{
        $0.setTitle("비디오", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        $0.backgroundColor = .blue
    }
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setting()
        bind()
    }
    
    @IBAction func clickGooglePlaces(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "GoogleMapView", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: "GoogleMapView") as? GoogleMapViewController else {
            return
        }
        getNavigationController().pushViewController(vc, animated: true)    }
    
    private func setting(){
        self.view.addSubview(btnStackView)
        
        [goTranslator, goAudioView, goVideoView].forEach{
            btnStackView.addArrangedSubview($0)
        }
        
        btnStackView.snp.makeConstraints{
            $0.top.equalTo(googleMapBtn.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }

    }
    
    private func bind(){
        goTranslator.rx.tap
            .bind{ [unowned self] in
                let view = TranslatorView(frame: .zero)
                self.view.addSubview(view)
                view.snp.makeConstraints{
                    $0.edges.equalToSuperview()
                }
            }
            .disposed(by: disposeBag)
        
        goAudioView.rx.tap
            .bind{ [unowned self] in
                let view = AudioRecordView(frame: .zero)
                self.view.addSubview(view)
                view.snp.makeConstraints{
                    $0.edges.equalToSuperview()
                }
            }
            .disposed(by: disposeBag)
        
        goVideoView.rx.tap
            .bind{ [unowned self] in
                let view = VideoView(frame: .zero)
                self.view.addSubview(view)
                view.snp.makeConstraints{
                    $0.edges.equalToSuperview()
                }
            }
            .disposed(by: disposeBag)
    }
}


