//
//  ThumbImageCellViewModel.swift
//  CodingSession
//
//  Created by Dzmitry Pats on 14.11.24.
//

import Foundation
import Photos
import UIKit

class ThumbImageCellViewModel {
    internal init(asset: PHAsset, thumbImageService: ThumbImageSupporter = ThumbImageService()) {
        self.asset = asset
        self.thumbImageService = thumbImageService
    }

    var asset: PHAsset

    private var thumbImageService: ThumbImageSupporter = ThumbImageService()
    private var imageRequestID: PHImageRequestID?

    func fetchImage(targetSize: CGSize, completion: @escaping (UIImage?) -> Void) {
        if let imageRequestID = imageRequestID {
            thumbImageService.cancelImageRequest(imageRequestID: imageRequestID)
        }

        imageRequestID = thumbImageService.fetchThumbImage(asset: asset, targetSize: targetSize) { res in
            switch res {
            case .success(let image):
                completion(image)
            case .failure:
                completion(nil)
            }
        }
    }

    func cancelImageRequest() {
        if let imageRequestID = imageRequestID {
            thumbImageService.cancelImageRequest(imageRequestID: imageRequestID)
        }
    }

    func duration() -> String? {
        let formatter = DateComponentsFormatter.timeFormatter
        return formatter.string(from: asset.duration)
    }
}
