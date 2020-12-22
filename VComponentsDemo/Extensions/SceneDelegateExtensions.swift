//
//  SceneDelegateExtensions.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI

// MARK:- Changing Root
extension SceneDelegate {
    static func changeRootView<Content>(
        to view: Content
    )
        where Content: View
    {
        guard
            let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let windowScenedelegate = scene.delegate as? SceneDelegate
        else {
            return
        }
        
        windowScenedelegate.window?.rootViewController = UIHostingController(rootView: view)
    }
}
