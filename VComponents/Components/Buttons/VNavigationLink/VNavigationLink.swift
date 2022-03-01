//
//  VNavigationLink.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/9/21.
//

import SwiftUI

// MARK: - V Navigation Link
/// Button component that controls a navigation presentation.
///
/// Button is meant to be used with button components from the library.
///
/// Model can be passed as parameter.
///
/// `isActive` can be passed as parameter.
///
/// Usage example:
///
///     var body: some View {
///         NavigationView(content: {
///             ZStack(content: {
///                 ColorBook.canvas.edgesIgnoringSafeArea(.all)
///
///                 VNavigationLink(
///                     destination: { destination },
///                     content: {
///                         VSecondaryButton(
///                             action: {},
///                             title: "Lorem Ipsum"
///                         )
///                     }
///                 )
///             })
///                 .navigationTitle("Home")
///                 .navigationBarTitleDisplayMode(.inline)
///         })
///     }
///
///     var destination: some View {
///         ColorBook.canvas.edgesIgnoringSafeArea(.all)
///            .navigationTitle("Destination")
///            .navigationBarTitleDisplayMode(.inline)
///     }
///
///
/// Alternatively, navigation can occur via `vNavigationLink` modifier.
public struct VNavigationLink<Destination, Content>: View
    where
        Destination: View,
        Content: View
{
    // MARK: Properties
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    @State private var isActiveInternally: Bool = false
    @Binding private var isActiveExternally: Bool
    private let stateManagament: ComponentStateManagement
    private var isActive: Binding<Bool> {
        .init(
            get: {
                switch stateManagament {
                case .internal: return isActiveInternally
                case .external: return isActiveExternally
                }
            },
            set: { value in
                switch stateManagament {
                case .internal: isActiveInternally = value
                case .external: isActiveExternally = value
                }
            }
        )
    }
    
    private let destination: () -> Destination
    private let content: () -> Content
    
    // MARK: Initializers
    /// Initializes component with destination and content.
    public init(
        @ViewBuilder destination: @escaping () -> Destination,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._isActiveExternally = .constant(false)
        self.stateManagament = .internal
        self.destination = destination
        self.content = content
    }
    
    /// Initializes component with active state, destination and content.
    public init(
        isActive: Binding<Bool>,
        @ViewBuilder destination: @escaping () -> Destination,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._isActiveExternally = isActive
        self.stateManagament = .external
        self.destination = destination
        self.content = content
    }

    // MARK: Body
    public var body: some View {
        NavigationLink(
            isActive: isActive,
            destination: destination,
            label: content
        )
            .buttonStyle(.plain) // Cancels styling
            .disabled(!isEnabled)
    }
}

// MARK: - Preview
struct VNavigationLink_Previews: PreviewProvider {
    private static var destination: some View {
        ColorBook.canvas.edgesIgnoringSafeArea(.all)
           .navigationTitle("Destination")
           .navigationBarTitleDisplayMode(.inline)
    }

    static var previews: some View {
        NavigationView(content: {
            ZStack(content: {
                ColorBook.canvas.edgesIgnoringSafeArea(.all)

                VNavigationLink(
                    destination: { destination },
                    content: {
                        VSecondaryButton(
                            action: {},
                            title: "Lorem Ipsum"
                        )
                    }
                )
            })
                .navigationTitle("Home")
                .navigationBarTitleDisplayMode(.inline)
        })
    }
}
