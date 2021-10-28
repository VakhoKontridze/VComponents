//
//  SceneDelegate.SetRoot.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI

// MARK: - Setting Root View
extension SceneDelegate {
    static func setRoot(to viewController: UIViewController) {
        guard
            let windowScene: UIWindowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let sceneDelegate: SceneDelegate = windowScene.delegate as? SceneDelegate
        else {
            return
        }

        sceneDelegate.window?.rootViewController = viewController
    }
    
    static func setRoot<Content>(to view: Content) where Content: View {
        setRoot(to: UIHostingController(rootView: view))
    }
}
