//
//  AssetLibraryService.swift
//  CodingSession
//
//  Created by Dzmitry Pats on 14.11.24.
//

import Foundation
import Photos

protocol AssetLibrarySupporter {
    func video() async -> [PHAsset]
}

class AssetLibraryService: AssetLibrarySupporter {
    func video() async -> [PHAsset] {
        await fetchAsset(type: .video)
    }
}

private extension AssetLibraryService {
    func fetchAsset(type: PHAssetMediaType) async -> [PHAsset] {
        await Task.detached(priority: .high) {
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "mediaType == %d", type.rawValue)

            let fetchResult = PHAsset.fetchAssets(with: fetchOptions)
            var videoAssets: [PHAsset] = []

            fetchResult.enumerateObjects { (asset, _, _) in
                videoAssets.append(asset)
            }
            return videoAssets
        }.value
    }
}
