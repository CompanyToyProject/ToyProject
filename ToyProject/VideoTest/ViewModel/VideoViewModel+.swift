//
//  VideoViewModel+.swift
//  ToyProject
//
//  Created by yeoboya-211221-05 on 2022/09/29.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit

extension VideoViewModel {
    
    func openVideoCollectionView(){
        
        let view = VideoCollectionView(frame: .zero)
        view.asset = AlbumManager.bringAlbumData(.video)
        getTopViewController().view.addSubview(view)
        view.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
    }
}
