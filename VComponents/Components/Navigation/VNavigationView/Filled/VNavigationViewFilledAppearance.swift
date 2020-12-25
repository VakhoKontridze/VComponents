//
//  VNavigationViewFilledAppearance.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI

// MARK:- Modifier
extension View {
    func setUpNavigationBarFilledAppearance(model: VNavigationViewFilledModel) -> some View {
        modifier(VNavigationViewFilledAppearance(model: model))
    }
}

// MARK:- V Navigation View Filled Appearance
struct VNavigationViewFilledAppearance: ViewModifier {
    init(
        model: VNavigationViewFilledModel
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
extension VNavigationViewFilledAppearance {
    func body(content: Content) -> some View {
        content
    }
}
