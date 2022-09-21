//
//  PapagoLanguageView.swift
//  ToyProject
//
//  Created by yeoboya-211221-05 on 2022/09/20.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxGesture
import SnapKit
import Then

protocol SelectedLanguageCodeProtocol {
    func isSelectedLanguageCode(papagoCode: String, appleCode: String, code: PapagoModel.Code)
}

class PapagoLanguageView: UIView {
    
    lazy var kingView = UIView().then{
        $0.backgroundColor = .white
    }
    
    lazy var mainView = UIView().then{
        $0.backgroundColor = .clear
    }
    
    lazy var mainStackView = UIStackView().then{
        $0.backgroundColor = .clear
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .fill
    }
    
    lazy var headerView = UIView().then{
        $0.backgroundColor = .clear
    }
    
    lazy var headerCloseBtn = UIButton().then{
        $0.setImage(TranslatorModel.arrow_down_image, for: .normal)
        $0.contentMode = .scaleToFill
    }
    
    lazy var headerText = UILabel().then{
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = UIFont.boldSystemFont(ofSize: 14)
    }
    
    lazy var boundaryView = UIView().then{
        $0.backgroundColor = .gray
    }

    lazy var recentlyLanguageView = UIView().then{
        $0.backgroundColor = .clear
    }
    
    lazy var allLanguageView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    lazy var tableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(PapagoCell.self, forCellReuseIdentifier: "PapagoCell")
        $0.backgroundColor = .white
    }
    
    let papagoModel = PapagoModel()
    var tableRowModel: [String] = []
    var papagoRowModel: [String] = []
    var disposeBag = DisposeBag()
    var delegate: SelectedLanguageCodeProtocol!
    var code: PapagoModel.Code?
    
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
        
        [headerView, boundaryView, recentlyLanguageView, allLanguageView].forEach{
            mainStackView.addArrangedSubview($0)
        }
        
        [headerCloseBtn, headerText].forEach{
            headerView.addSubview($0)
        }
        
        allLanguageView.addSubview(tableView)
        
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
            $0.height.equalTo(40)
        }
        
        headerCloseBtn.snp.makeConstraints{
            $0.left.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
        
        headerText.snp.makeConstraints{
            $0.center.equalToSuperview()
        }
        
        boundaryView.snp.makeConstraints{
            $0.height.equalTo(1)
        }
        
        tableView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        recentlyLanguageView.isHidden = true

    }
    
    private func firstSetting(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = 60
    }
    
    private func binding(){
        headerCloseBtn.rx.tap
            .bind{ [unowned self] in
                self.removeFromSuperview()
            }
            .disposed(by: disposeBag)
    }
    
    func selectModel(_ code: PapagoModel.Code){
        if code == .source {
            self.tableRowModel = papagoModel.sourceAppleCode
            self.papagoRowModel = papagoModel.sourceLanuageCode
            self.headerText.text = "이 언어로 입력"
            self.code = code
        }
        else {
            self.tableRowModel = papagoModel.targetAppleCode
            self.papagoRowModel = papagoModel.targetLanugaeCode
            self.headerText.text = "이 언어로 번역"
            self.code = code
        }
    }
    
    deinit {
        log.d("PapagoLanguageView deinitdeinitdeinitdeinitdeinitdeinitdeinitdeinit")
    }
    
}

extension PapagoLanguageView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableRowModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PapagoCell.identifier, for: indexPath) as? PapagoCell else {
            return UITableViewCell()
        }
        
        cell.setView()
        
        let code = self.tableRowModel[indexPath.row]
        
        cell.codeText.text = code.localizeIdentifier()
        
        let tap = UITapGestureRecognizer()
        cell.addGestureRecognizer(tap)
        
        tap.rx.event
            .bind{ [unowned self] _ in
                let papagoCode = self.papagoRowModel[indexPath.row]
                self.delegate.isSelectedLanguageCode(papagoCode: papagoCode, appleCode: code, code: self.code!)
                self.removeFromSuperview()
            }
            .disposed(by: disposeBag)
        
        return cell
    }
    
    
}
