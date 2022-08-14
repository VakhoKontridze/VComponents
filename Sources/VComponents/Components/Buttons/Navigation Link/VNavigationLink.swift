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
/// UI Model can be passed as parameter.
///
/// `isActive` can be passed as parameter.
///
///     var body: some View {
///         NavigationView(content: {
///             ZStack(content: {
///                 ColorBook.canvas.ignoresSafeArea()
///
///                 VNavigationLink(
///                     destination: { destination },
///                     title: "Lorem Ipsum"
///                 )
///             })
///                 .navigationTitle("Home")
///                 .navigationBarTitleDisplayMode(.inline)
///         })
///     }
///
///     var destination: some View {
///         ColorBook.canvas.ignoresSafeArea()
///            .navigationTitle("Destination")
///            .navigationBarTitleDisplayMode(.inline)
///     }
///
///
/// Alternatively, navigation can occur via `vNavigationLink` modifier.
public struct VNavigationLink<Destination, Label>: View
    where
        Destination: View,
        Label: View
{
    // MARK: Properties
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    @State private var isActiveInternally: Bool = false
    @Binding private var isActiveExternally: Bool
    private let stateManagement: StateManagement
    private var isActive: Binding<Bool> {
        .init(
            get: {
                switch stateManagement {
                case .internal: return isActiveInternally
                case .external: return isActiveExternally
                }
            },
            set: { value in
                switch stateManagement {
                case .internal: isActiveInternally = value
                case .external: isActiveExternally = value
                }
            }
        )
    }
    
    private let destination: () -> Destination
    private let label: VNavigationLinkLabel<Label>
    
    // MARK: Initializers
    /// Initializes component with destination and label.
    public init(
        @ViewBuilder destination: @escaping () -> Destination,
        title: String
    )
        where Label == VPlainButton<Never>
    {
        self._isActiveExternally = .constant(false)
        self.stateManagement = .internal
        self.destination = destination
        self.label = .title(title: title)
    }
    
    /// Initializes component with destination and title.
    public init(
        @ViewBuilder destination: @escaping () -> Destination,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self._isActiveExternally = .constant(false)
        self.stateManagement = .internal
        self.destination = destination
        self.label = .custom(label: label)
    }

    // MARK: Initializers - Bool
    /// Initializes component with active state, destination and label.
    public init(
        isActive: Binding<Bool>,
        @ViewBuilder destination: @escaping () -> Destination,
        title: String
    )
        where Label == VPlainButton<Never>
    {
        self._isActiveExternally = isActive
        self.stateManagement = .external
        self.destination = destination
        self.label = .title(title: title)
    }
    
    /// Initializes component with active state, destination and title.
    public init(
        isActive: Binding<Bool>,
        @ViewBuilder destination: @escaping () -> Destination,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self._isActiveExternally = isActive
        self.stateManagement = .external
        self.destination = destination
        self.label = .custom(label: label)
    }

    // MARK: Body
    public var body: some View {
        NavigationLink(
            isActive: isActive,
            destination: destination,
            label: buttonLabel
        )
            .buttonStyle(.plain) // Cancels styling
            .disabled(!isEnabled)
    }
    
    @ViewBuilder private func buttonLabel() -> some View {
        switch label {
        case .title(let title):
            VPlainButton(action: {}, title: title)
            
        case .custom(let label):
            label()
        }
    }
    
    // MARK: State Management
    private enum StateManagement {
        case `internal`
        case external
    }
}

// MARK: - Preview
struct VNavigationLink_Previews: PreviewProvider {
    private static var destination: some View {
        ColorBook.canvas.ignoresSafeArea()
           .navigationTitle("Destination")
           .navigationBarTitleDisplayMode(.inline)
    }

    static var previews: some View {
        NavigationView(content: {
            ZStack(content: {
                ColorBook.canvas.ignoresSafeArea()

                VNavigationLink(
                    destination: { destination },
                    title: "Lorem Ipsum"
                )
            })
                .navigationTitle("Home")
                .navigationBarTitleDisplayMode(.inline)
        })
    }
}
