//
//  VNavigationView.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI

// MARK:- V Navigation View
/// Navigation component that presents stack of views with a visible path in a navigation hierarchy
public struct VNavigationView<Content>: View where Content: View {
    // MARK: Properties
    private let model: VNavigationViewModel
    private let content: () -> Content
    
    // MARK: Initializers
    /// Initializes component with content
    ///
    /// - Parameters:
    ///   - model: Model that describes UI
    ///   - content: Navigation root. VBaseView should be used.
    public init(
        model: VNavigationViewModel = .init(),
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.model = model
        self.content = content
    }
}

// MARK:- Body
extension VNavigationView {
    public var body: some View {
        NavigationView(content: {
            content()
                .setUpNavigationViewNavigationBar()
        })
            .navigationViewStyle(StackNavigationViewStyle())
            .setUpNavigationBarAppearance(model: model)
    }
}

// MARK:- Preview
struct VNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        VBaseView_Previews.previews
    }
}
