//
//  PapagoCell.swift
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

class PapagoCell: UITableViewCell {
    
    static let identifier = "PapagoCell"
    
    lazy var mainView = UIView().then{
        $0.backgroundColor = .white
    }
    
    lazy var codeView = UIView().then{
        $0.backgroundColor = .clear
    }
    
    lazy var codeText = UILabel().then {
        $0.textAlignment = .center
        $0.font = UIFont.boldSystemFont(ofSize: 14)
        $0.textColor = .black
    }
    
    lazy var boundaryView = UIView().then{
        $0.backgroundColor = .black
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setView(){
        addSubview(mainView)
        
        [codeView, boundaryView].forEach{
            mainView.addSubview($0)
        }
        
        codeView.addSubview(codeText)
        
        setConstraints()
    }
    
    func setConstraints(){
        mainView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        codeView.snp.makeConstraints{
            $0.left.top.right.equalToSuperview()
        }
        
        codeText.snp.makeConstraints{
            $0.center.equalToSuperview()
        }
        
        boundaryView.snp.makeConstraints{
            $0.left.bottom.right.equalToSuperview()
            $0.top.equalTo(codeView.snp.bottom)
            $0.height.equalTo(1)
        }
    }
    
}
