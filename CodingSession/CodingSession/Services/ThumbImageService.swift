//
//  ThumbImageService.swift
//  CodingSession
//
//  Created by Dzmitry Pats on 14.11.24.
//

import UIKit
import Photos

enum ValidationError: Error {
    case thumbImage(details: [AnyHashable : Any]?)
}

protocol ThumbImageSupporter {
    func fetchThumbImage(asset: PHAsset,
                         targetSize: CGSize,
                         completable: @escaping (Result<UIImage, Error>) -> Void) -> PHImageRequestID
    func cancelImageRequest(imageRequestID: PHImageRequestID)
    func fetchThumbImage(asset: PHAsset, targetSize: CGSize) -> Task<UIImage, Error>
}

class ThumbImageService: ThumbImageSupporter {
    let manager = PHImageManager.default()

    func fetchThumbImage(asset: PHAsset,
                         targetSize: CGSize,
                         completable: @escaping (Result<UIImage, Error>) -> Void) -> PHImageRequestID {
        let requestOptions = PHImageRequestOptions()

        requestOptions.isSynchronous = false
        requestOptions.deliveryMode = .highQualityFormat

        return manager.requestImage(for: asset,
                                    targetSize: targetSize,
                                    contentMode: .aspectFill,
                                    options: requestOptions) { (image, detailsError) in
            guard let imageU = image else {
                completable(.failure(ValidationError.thumbImage(details: detailsError)))
                return
            }
            completable(.success(imageU))
        }
    }

    func cancelImageRequest(imageRequestID: PHImageRequestID) {
        manager.cancelImageRequest(imageRequestID)
    }

    func fetchThumbImage(asset: PHAsset,
                         targetSize: CGSize) -> Task<UIImage, Error> {
        return Task { () throws -> UIImage in
            try await withCheckedThrowingContinuation { continuation in
                let manager = PHImageManager.default()
                let requestOptions = PHImageRequestOptions()

                requestOptions.isSynchronous = false
                requestOptions.deliveryMode = .highQualityFormat

                manager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: requestOptions) { (image, detailsError) in
                    if let image = image {
                        continuation.resume(returning: image)
                    } else {
                        continuation.resume(throwing: ValidationError.thumbImage(details: nil))
                    }
                }
            }
        }
    }
}
