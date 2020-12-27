//
//  VNavigationViewAppearanceFilled.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI

// MARK:- Modifier
extension View {
    func setUpNavigationBarAppearanceFilled(model: VNavigationViewModelFilled) -> some View {
        modifier(VNavigationViewAppearanceFilled(model: model))
    }
}

// MARK:- V Navigation View Appearance Filled
struct VNavigationViewAppearanceFilled: ViewModifier {
    init(
        model: VNavigationViewModelFilled
    ) {
        let appearance: UINavigationBarAppearance = {
            let appearance: UINavigationBarAppearance = .init()
            
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .init(model.colors.background)
            
            appearance.shadowColor = .init(model.colors.divider)
            
            return appearance
        }()

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
}

// MARK:- View
extension VNavigationViewAppearanceFilled {
    func body(content: Content) -> some View {
        content
    }
}
