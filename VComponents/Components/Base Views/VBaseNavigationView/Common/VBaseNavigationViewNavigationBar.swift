//
//  VBaseNaviationViewNavigationBar.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI

// MARK:- Modifier
extension View {
    func setUpBaseNavigationViewNavigationBar() -> some View {
        modifier(VBaseNaviggationViewNavigationBar())
    }
}

// MARK:- V Base Navigation View Navigation Bar
struct VBaseNaviggationViewNavigationBar: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationBarTitleDisplayMode(.inline)
    }
}
