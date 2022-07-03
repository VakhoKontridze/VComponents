//
//  SceneDelegate.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 18.12.20.
//

import UIKit
import SwiftUI

// MARK: - Scene Delegate
final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    // MARK: Properties
    var window: UIWindow?

    // MARK: Window Scene Delegate
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene: UIWindowScene = scene as? UIWindowScene else { return }
        
        window = .init(windowScene: windowScene)
        window?.rootViewController = UIHostingController(rootView: HomeView())
        window?.makeKeyAndVisible()
    }
}
