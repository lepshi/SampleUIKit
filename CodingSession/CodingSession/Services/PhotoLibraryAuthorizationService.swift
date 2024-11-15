//
//  PhotoLibraryAuthorizationService.swift
//  CodingSession
//
//  Created by Dzmitry Pats on 15.11.24.
//

import Photos

protocol PhotoLibraryAuthorizationSupporter {
    func checkAuthorization() async -> PhotoLibraryAuthorizationStatus
}

class PhotoLibraryAuthorizationService: PhotoLibraryAuthorizationSupporter {
    func checkAuthorization() async -> PhotoLibraryAuthorizationStatus {
        let photoLibraryStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        if let status = authorizationStatus(photoLibraryStatus) {
            return status
        }
        let status = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
        return authorizationStatus(status) ?? .denied
    }
}

// MARK: - Private

private extension PhotoLibraryAuthorizationService {
    func authorizationStatus(_ status: PHAuthorizationStatus) -> PhotoLibraryAuthorizationStatus? {
        switch status {
        case .authorized:
            return .authorized
        case .notDetermined:
            return nil
        case .limited:
            return .limited
        default:
            return .denied
        }
    }
}
