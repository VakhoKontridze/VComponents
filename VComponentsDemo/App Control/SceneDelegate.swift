//
//  SceneDelegate.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 18.12.20.
//

import UIKit
import SwiftUI

// MARK: - Scene Delegate
final class SceneDelegate: UIResponder {
    // MARK: Propeties
    var window: UIWindow?
}

// MARK: - Delegate
extension SceneDelegate: UIWindowSceneDelegate {
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        window = .init(windowScene: windowScene)
        let homeView: HomeView = .init()
        window?.rootViewController = UIHostingController(rootView: homeView)
        window?.makeKeyAndVisible()
    }
}
