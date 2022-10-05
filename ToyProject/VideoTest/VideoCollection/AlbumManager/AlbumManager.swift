//
//  AlbumManager.swift
//  ToyProject
//
//  Created by yeoboya-211221-05 on 2022/09/29.
//

import Foundation
import UIKit
import Photos
import SnapKit

class AlbumManager {
    
    static var asset: PHFetchResult<PHAsset>?
    
    static func bringAlbumData(_ mediaType: PHAssetMediaType) -> PHFetchResult<PHAsset>? {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        asset = PHAsset.fetchAssets(with: mediaType, options: options)
        log.d(asset)
        return asset
    }
    
}
