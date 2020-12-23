//
//  VBaseNavigationViewAppearance.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI

// MARK:- Modifier
extension View {
    func setUpBaseNavigationBarAppearance(model: VBaseNavigationViewModel) -> some View {
        modifier(VBaseNavigationViewAppearance(model: model))
    }
}

// MARK:- V Base Navigation View Appearance
struct VBaseNavigationViewAppearance: ViewModifier {
    init(
        model: VBaseNavigationViewModel
    ) {
        let appearance: UINavigationBarAppearance = {
            let appearance: UINavigationBarAppearance = .init()
            
            switch model.colors.background {
            case .filled(let color):
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = .init(color)
            
            case .transparent:
                appearance.configureWithTransparentBackground()
                appearance.backgroundColor = .clear
            }
            
            appearance.shadowColor = .init(model.colors.divider)
            
            return appearance
        }()

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
}

// MARK:- View
extension VBaseNavigationViewAppearance {
    func body(content: Content) -> some View {
        content
    }
}
