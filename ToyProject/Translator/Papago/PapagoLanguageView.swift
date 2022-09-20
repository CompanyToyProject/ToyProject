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
import SnapKit
import Then

class PapagoLanguageView: UIView {
    
    lazy var kingView = UIView().then{
        $0.backgroundColor = .white
    }
    
    lazy var mainView = UIView().then{
        $0.backgroundColor = .clear
    }
    
    lazy var headerView = UIView().then{
        $0.backgroundColor = .clear
    }
    
    
    lazy var tableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(PapagoCell.self, forCellReuseIdentifier: "PapagoCell")
        $0.backgroundColor = .white
    }
    
    let papagoModel = PapagoModel()
    var tableRowModel: [String] = []
    
    override init(frame: CGRect) {
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
        
        mainView.addSubview(tableView)
    }
    
    private func setConstraints(){
        kingView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        mainView.snp.makeConstraints{
            $0.edges.equalTo(kingView.safeAreaLayoutGuide)
        }
        
        tableView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
    private func firstSetting(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = 40
    }
    
    func selectModel(_ code: PapagoModel.Code){
        if code == .source {
            self.tableRowModel = papagoModel.sourceAppleCode
        }
        else {
            self.tableRowModel = papagoModel.targetAppleCode
        }
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
        return cell
    }
    
    
}
