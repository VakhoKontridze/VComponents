//
//  VNaviationViewNavigationBar.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI

// MARK:- Modifier
extension View {
    func setUpNavigationViewNavigationBar() -> some View {
        modifier(VNaviggationViewNavigationBar())
    }
}

// MARK:- V Navigation View Navigation Bar
struct VNaviggationViewNavigationBar: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navBarTitleDisplayMode(.inline)
    }
}
