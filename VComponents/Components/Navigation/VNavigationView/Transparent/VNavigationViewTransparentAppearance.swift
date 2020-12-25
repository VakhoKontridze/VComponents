//
//  VNavigationViewTransparentAppearance.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK:- Modifier
extension View {
    func setUpNavigationBarTransparentAppearance(model: VNavigationViewTransparentModel) -> some View {
        modifier(VNavigationViewTransparentAppearance(model: model))
    }
}

// MARK:- V Navigation View Transparent Appearance
struct VNavigationViewTransparentAppearance: ViewModifier {
    init(
        model: VNavigationViewTransparentModel
    ) {
        let appearance: UINavigationBarAppearance = {
            let appearance: UINavigationBarAppearance = .init()
            
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = .clear
            
            appearance.shadowColor = .init(model.colors.divider)
            
            return appearance
        }()

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
}

// MARK:- View
extension VNavigationViewTransparentAppearance {
    func body(content: Content) -> some View {
        content
    }
}
