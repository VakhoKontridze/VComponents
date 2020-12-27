//
//  VTabNavigationViewAppearanceStandard.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI

// MARK:- Modifier
extension View {
    func setUpTabNavigationViewAppearanceStandard(model: VTabNavigationViewModelStandard) -> some View {
        modifier(VTabNavigationViewAppearanceStandard(model: model))
    }
}

// MARK:- V Navigation View Appearance Filled
struct VTabNavigationViewAppearanceStandard: ViewModifier {
    // MARK: Properties
    private let model: VTabNavigationViewModelStandard
    
    // MARK: Initializers
    init(
        model: VTabNavigationViewModelStandard
    ) {
        self.model = model
        
        UITabBar.appearance().barTintColor = .init(model.colors.background)

        UITabBar.appearance().unselectedItemTintColor = .init(model.colors.item)
    }
}

// MARK:- View
extension VTabNavigationViewAppearanceStandard {
    func body(content: Content) -> some View {
        content
            .accentColor(model.colors.itemSelected)
    }
}
