//
//  VBaseNavigationViewTransparentAppearance.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK:- Modifier
extension View {
    func setUpBaseNavigationBarTransparentAppearance(model: VBaseNavigationViewTransparentModel) -> some View {
        modifier(VBaseNavigationViewTransparentAppearance(model: model))
    }
}

// MARK:- V Base Navigation View Transparent Appearance
struct VBaseNavigationViewTransparentAppearance: ViewModifier {
    init(
        model: VBaseNavigationViewTransparentModel
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
extension VBaseNavigationViewTransparentAppearance {
    func body(content: Content) -> some View {
        content
    }
}
