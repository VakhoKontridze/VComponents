//
//  VNavigationViewAppearance.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI

// MARK: - Modifier
extension View {
    func setUpNavigationBarAppearance(model: VNavigationViewModel) -> some View {
        modifier(VNavigationViewAppearance(model: model))
    }
}

// MARK: - V Navigation View Appearance
struct VNavigationViewAppearance: ViewModifier {
    init(
        model: VNavigationViewModel
    ) {
        let appearance: UINavigationBarAppearance = {
            let appearance: UINavigationBarAppearance = .init()

            appearance.backgroundColor = .init(model.colors.bar)
            if model.colors.bar == .clear { appearance.configureWithTransparentBackground() }
            
            appearance.shadowColor = .init(model.colors.divider)

            return appearance
        }()
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }

    // MARK: Body
    func body(content: Content) -> some View {
        content
    }
}
