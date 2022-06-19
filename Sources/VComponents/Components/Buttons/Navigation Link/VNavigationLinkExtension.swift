//
//  VNavigationLinkExtension.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 8/26/21.
//

import SwiftUI
import VCore

// MARK: - Extension
extension View {
    /// Allows for navigation without an explicit `NavigationLink`.
    ///
    ///     @State var isActive: Bool = false
    ///
    ///     var body: some View {
    ///         NavigationView(content: {
    ///             ZStack(content: {
    ///                 ColorBook.canvas.ignoresSafeArea()
    ///
    ///                 VPlainButton(
    ///                     action: { isActive = true },
    ///                     title: "Lorem Ipsum"
    ///                 )
    ///             })
    ///                 .navigationTitle("Home")
    ///                 .navigationBarTitleDisplayMode(.inline)
    ///                 .vNavigationLink(isActive: $isActive, destination: { destination })
    ///         })
    ///     }
    ///
    ///     var destination: some View {
    ///         ColorBook.canvas.ignoresSafeArea()
    ///            .navigationTitle("Destination")
    ///            .navigationBarTitleDisplayMode(.inline)
    ///     }
    ///
    public func vNavigationLink(
        isActive: Binding<Bool>,
        @ViewBuilder destination: @escaping () -> some View
    ) -> some View {
        navigationLink(
            isActive: isActive,
            destination: destination
        )
    }
}
