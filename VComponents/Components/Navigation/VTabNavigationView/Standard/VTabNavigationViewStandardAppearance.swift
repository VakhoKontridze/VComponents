//
//  VTabNavigationViewStandardAppearance.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI

// MARK:- Modifier
extension View {
    func setUpTabNavigationViewStandardAppearance(model: VTabNavigationViewStandardModel) -> some View {
        modifier(VTabNavigationViewStandardAppearance(model: model))
    }
}

// MARK:- V Navigation View Filled Appearance
struct VTabNavigationViewStandardAppearance: ViewModifier {
    // MARK: Properties
    private let model: VTabNavigationViewStandardModel
    
    // MARK: Initializers
    init(
        model: VTabNavigationViewStandardModel
    ) {
        self.model = model
        
        UITabBar.appearance().barTintColor = .init(model.colors.background)

        UITabBar.appearance().unselectedItemTintColor = .init(model.colors.item)
    }
}

// MARK:- View
extension VTabNavigationViewStandardAppearance {
    func body(content: Content) -> some View {
        content
            .accentColor(model.colors.itemSelected)
    }
}
