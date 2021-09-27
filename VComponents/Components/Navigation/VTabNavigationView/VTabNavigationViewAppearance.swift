//
//  VTabNavigationViewAppearance.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI

// MARK: - Modifier
extension View {
    func setUpTabNavigationViewAppearance(model: VTabNavigationViewModel) -> some View {
        modifier(VTabNavigationViewAppearance(model: model))
    }
}

// MARK: - V Navigation View Appearance
struct VTabNavigationViewAppearance: ViewModifier {
    // MARK: Properties
    private let model: VTabNavigationViewModel
    
    // MARK: Initializers
    init(
        model: VTabNavigationViewModel
    ) {
        self.model = model
        
        UITabBar.appearance().barTintColor = .init(model.colors.background)

        UITabBar.appearance().unselectedItemTintColor = .init(model.colors.item)
    }

    // MARK: Body
    func body(content: Content) -> some View {
        content
            .accentColor(model.colors.selectedItem)
    }
}
