//
//  VNavigationLinkExtension.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 8/26/21.
//

import SwiftUI

// MARK: - Extension
extension View {
    /// Allows for navigation without an explicit `NavigationLink`.
    ///
    /// Usage example:
    ///
    ///     @State var isActive: Bool = false
    ///
    ///     var body: some View {
    ///         NavigationView(content: {
    ///             ZStack(content: {
    ///                 ColorBook.canvas.edgesIgnoringSafeArea(.all)
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
    ///         ColorBook.canvas.edgesIgnoringSafeArea(.all)
    ///            .navigationTitle("Destination")
    ///            .navigationBarTitleDisplayMode(.inline)
    ///     }
    ///
    @ViewBuilder public func vNavigationLink<Destination>(
        isActive: Binding<Bool>,
        @ViewBuilder destination: @escaping () -> Destination
    ) -> some View
        where Destination: View
    {
        self
            .background(
                NavigationLink(
                    isActive: isActive,
                    destination: destination,
                    label: { EmptyView() }
                )
                    .allowsHitTesting(false)
                    .opacity(0)
            )
    }
}
