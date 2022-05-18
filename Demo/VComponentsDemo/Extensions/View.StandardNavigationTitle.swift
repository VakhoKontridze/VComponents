//
//  View.StandardNavigationTitle.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 2/27/22.
//

import SwiftUI

// MARK: - Extension
@available(iOS 14, *)
extension View {
    func standardNavigationTitle(_ title: String) -> some View {
        self
            .modifier(StandardNavigationTitle(title))
    }
}

// MARK: - Standard Navigation Title View Modifier
@available(iOS 14, *)
private struct StandardNavigationTitle: ViewModifier {
    // MARK: Properties
    private let title: String
    
    // MARK: Initializers
    fileprivate init(_ title: String) {
        self.title = title
    }

    // MARK: Body
    fileprivate func body(content: Content) -> some View {
        content
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
    }
}
