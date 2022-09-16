//
//  SearchBarView.swift
//  TestMap
//
//  Created by yeoboya on 2022/09/15.
//

import Foundation
import UIKit
import SnapKit
import Then
import RxSwift

class SearchBarView: UIView {
    
    var tableView = UITableView()
    var tableViewController: RegionTableViewController?
    
    let bgView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 22
        $0.layer.applySketchShadow(color: .black, alpha: 0.2, x: 0, y: 3, blur: 6, spread: 0)
    }
    
    let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 2
    }
    
    let textViewContainer = UIView()
    
    let placeHolderLabel = UILabel().then {
        $0.textColor = .lightGray
        $0.textAlignment = .left
        $0.font = .systemFont(ofSize: 15)
        $0.text = "Search Region!!"
    }
    
    let textView = UITextView().then {
        $0.textColor = .black
        $0.textAlignment = .left
        $0.font = .systemFont(ofSize: 15)
        $0.textContainerInset = UIEdgeInsets(top: 1.5, left: 0, bottom: 1.5, right: 0)
    }
    
    let micBtn = UIButton().then {
        $0.setImage(UIImage(systemName: "mic.fill"), for: .normal)
    }
    
    let searchBtn = UIButton().then {
        $0.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
    }
    
    var selectItem = PublishSubject<LocalCoordinate>()
    var disposeBag = DisposeBag()
    
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
        
        textView.delegate = self
        
        setTableViewController()
        bind()
    }
    
    func configUI(arr: [LocalCoordinate]) {
        tableViewController?.arr = arr
    }
    
    func setTableViewController() {
        tableViewController = RegionTableViewController(tableView: self.tableView)
    }
    
    private func setUI() {
        
        [
            tableView,
            bgView
        ].forEach { self.addSubview($0) }
        
        bgView.addSubview(stackView)
        
        [
            textViewContainer,
            micBtn,
            searchBtn
        ].forEach { stackView.addArrangedSubview($0) }
        
        [
            textView,
            placeHolderLabel
        ].forEach { textViewContainer.addSubview($0) }
        
    }
    
    private func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(bgView.snp.bottom)
            make.leading.trailing.equalTo(bgView).inset(18)
            make.height.equalTo(0)
            make.bottom.equalToSuperview().inset(10)
        }
        
        bgView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(10)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(4)
            make.leading.trailing.equalToSuperview().inset(18)
        }
        
        micBtn.snp.makeConstraints { make in
            make.width.height.equalTo(36)
        }
        
        searchBtn.snp.makeConstraints { make in
            make.width.height.equalTo(36)
        }
        
        textView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(8)
        }
        
        placeHolderLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(8)
        }
    }
    
    func tableViewZeroHeight() {
        tableView.snp.updateConstraints { make in
            make.height.equalTo(0)
        }
    }
    
    deinit {
        tableViewController?.disposeBag = DisposeBag()
        print("SearchBarView Deinit...")
    }
}
