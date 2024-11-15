//
//  SceneDelegate.swift
//  CodingSession
//
//  Created by Dzmitry Pats on 15.11.24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let multiplePhotoViewController = MultiplePhotoViewController()
        window.rootViewController = multiplePhotoViewController
        window.makeKeyAndVisible()
        self.window = window
    }
}

