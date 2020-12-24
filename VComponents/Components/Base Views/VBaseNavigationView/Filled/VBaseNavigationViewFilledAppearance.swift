//
//  VBaseNavigationViewFilledAppearance.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI

// MARK:- Modifier
extension View {
    func setUpBaseNavigationBarFilledAppearance(model: VBaseNavigationViewFilledModel) -> some View {
        modifier(VBaseNavigationViewFilledAppearance(model: model))
    }
}

// MARK:- V Base Navigation View Filled Appearance
struct VBaseNavigationViewFilledAppearance: ViewModifier {
    init(
        model: VBaseNavigationViewFilledModel
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
extension VBaseNavigationViewFilledAppearance {
    func body(content: Content) -> some View {
        content
    }
}
