//
//  MultiplePhotoViewModel.swift
//  CodingSession
//
//  Created by Dzmitry Pats on 15.11.24.
//

import Foundation
import Photos

protocol MultiplePhotoSupporter: AnyObject {
    var assets: AsyncStream<[PHAsset]> { get }
}

class MultiplePhotoViewModel: MultiplePhotoSupporter {
    var assetLibraryService: AssetLibrarySupporter
    var photoLibraryAuthorizationService: PhotoLibraryAuthorizationSupporter

    deinit {
        continuationAssets?.finish()
    }

    init(assetLibraryService: AssetLibrarySupporter = AssetLibraryService(),
         photoLibraryAuthorizationService: PhotoLibraryAuthorizationSupporter = PhotoLibraryAuthorizationService()) {
        self.assetLibraryService = assetLibraryService
        self.photoLibraryAuthorizationService = photoLibraryAuthorizationService
        run()
    }

    private var continuationAssets: AsyncStream<[PHAsset]>.Continuation?

    var assets: AsyncStream<[PHAsset]> {
        AsyncStream { continuation in
            self.continuationAssets = continuation
        }
    }
}

private extension MultiplePhotoViewModel {
    func sendAssets(_ assets: [PHAsset]) {
        continuationAssets?.yield(assets)
    }

    func run() {
        Task {
            let result = await checkStatus()
            guard result else { return }
            let assets = await assetLibraryService.video()
            self.sendAssets(assets)
        }
    }

    func checkStatus() async -> Bool {
        let result = await photoLibraryAuthorizationService.checkAuthorization()
        switch result {
        case .authorized, .limited:
            return true
        case .denied:
            return false
        }
    }
}
