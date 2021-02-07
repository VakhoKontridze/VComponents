//
//  VNavigationLink.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/9/21.
//

import SwiftUI

// MARK:- V Navigation Link
/// Button component that controls a navigation presentation
///
/// Component can be initialized with content or title.
///
/// Component supports presets or existing button types.
///
/// State can be passed as parameter
///
/// # Usage Example #
/// 
/// ```
/// var body: some View {
///     VNavigationView(content: {
///         VBaseView(title: "Home", content: {
///             ZStack(content: {
///                 ColorBook.canvas.edgesIgnoringSafeArea(.all)
///
///                 VSheet()
///
///                 VNavigationLink(
///                     preset: .secondary(),
///                     destination: destination,
///                     title: "Lorem ipsum"
///                 )
///             })
///         })
///     })
/// }
///
/// var destination: some View {
///     VBaseView(title: "Destination", content: {
///         ZStack(content: {
///             ColorBook.canvas.edgesIgnoringSafeArea(.all)
///
///             VSheet()
///         })
///     })
/// }
/// ```
///
public struct VNavigationLink<Destination, Label>: View
    where
        Destination: View,
        Label: View
{
    // MARK: Properties
    private let navLinkButtonType: VNavigationLinkType
    
    private let state: VNavigationLinkState
    
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
    
    private let destination: Destination
    private let label: () -> Label
    
    // MARK: Initializers: Preset and Tap
    public init(
        preset navLinkPreset: VNavigationLinkPreset,
        state: VNavigationLinkState = .enabled,
        destination: Destination,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.navLinkButtonType = navLinkPreset.buttonType
        self.state = state
        self._isActiveExternally = .constant(false)
        self.stateManagament = .internal
        self.destination = destination
        self.label = label
    }
    
    public init(
        preset navLinkPreset: VNavigationLinkPreset,
        state: VNavigationLinkState = .enabled,
        destination: Destination,
        title: String
    )
        where Label == VText
    {
        self.init(
            preset: navLinkPreset,
            state: state,
            destination: destination,
            label: { navLinkPreset.text(from: title, isEnabled: state.isEnabled) }
        )
    }
    
    // MARK: Initializers: Preset and State
    public init(
        preset navLinkPreset: VNavigationLinkPreset,
        state: VNavigationLinkState = .enabled,
        isActive: Binding<Bool>,
        destination: Destination,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.navLinkButtonType = navLinkPreset.buttonType
        self.state = state
        self._isActiveExternally = isActive
        self.stateManagament = .external
        self.destination = destination
        self.label = label
    }
    
    public init(
        preset navLinkPreset: VNavigationLinkPreset,
        state: VNavigationLinkState = .enabled,
        isActive: Binding<Bool>,
        destination: Destination,
        title: String
    )
        where Label == VText
    {
        self.init(
            preset: navLinkPreset,
            state: state,
            isActive: isActive,
            destination: destination,
            label: { navLinkPreset.text(from: title, isEnabled: state.isEnabled) }
        )
    }
    
    // MARK: Initializers: Custom and Tap
    public init(
        state: VNavigationLinkState = .enabled,
        destination: Destination,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.navLinkButtonType = .custom
        self.state = state
        self._isActiveExternally = .constant(false)
        self.stateManagament = .internal
        self.destination = destination
        self.label = label
    }
    
    // MARK: Initializers: Custom and State
    public init(
        state: VNavigationLinkState = .enabled,
        isActive: Binding<Bool>,
        destination: Destination,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.navLinkButtonType = .custom
        self.state = state
        self._isActiveExternally = isActive
        self.stateManagament = .external
        self.destination = destination
        self.label = label
    }
}

// MARK:- Body
extension VNavigationLink {
    public var body: some View {
        labelView(isActive: isActive)
            .background({
                NavigationLink(destination: destinationView, isActive: isActive, label: { EmptyView() })
                    .allowsHitTesting(false)
                    .opacity(0)
            }())
    }
    
    private func labelView(isActive: Binding<Bool>) -> some View {
        VNavigationLinkType.navLinkButton(
            buttonType: navLinkButtonType,
            isEnabled: state.isEnabled,
            action: { isActive.wrappedValue = true },
            label: label
        )
    }
    
    private var destinationView: some View {
        destination.environment(\.vNavigationViewBackButtonHidden, false)
    }
}

// MARK:- Preview
struct VNavigationLink_Previews: PreviewProvider {
    private static var destination: some View {
        VBaseView(title: "Destination", content: {
            ZStack(content: {
                ColorBook.canvas.edgesIgnoringSafeArea(.all)
                
                VSheet()
            })
        })
    }
    
    static var previews: some View {
        VNavigationView(content: {
            VBaseView(title: "Home", content: {
                ZStack(content: {
                    ColorBook.canvas.edgesIgnoringSafeArea(.all)
                    
                    VSheet()
                    
                    VNavigationLink(
                        preset: .secondary(),
                        destination: destination,
                        title: "Lorem ipsum"
                    )
                })
            })
        })
    }
}
