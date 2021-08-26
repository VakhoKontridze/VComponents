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
/// `VNavigationView` and `VNavigationLink` can cause unintended effect in your navigation hierarchy if used alongside with `SwiftUI`'s native `NavigationView` and `NavigationLink`.
/// To handle back button on detail views automatically, default back buttons are hidden, and custom ones are added as long as navigation happens via `VNavigationLink`.
///
/// # Usage Example #
///
/// ```
/// var destination: some View {
///     VBaseView(title: "Destination", content: {
///         ZStack(content: {
///             ColorBook.canvas.edgesIgnoringSafeArea(.all)
///
///             VSheet()
///         })
///     })
/// }
///
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
/// ```
///
/// Alternate navigation can be completed using `vNavigationLink` `ViewModifier`:
///
/// ```
/// @State var isActive: Bool = false
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
///
/// var body: some View {
///     VNavigationView(content: {
///         VBaseView(title: "Home", content: {
///             ZStack(content: {
///                 ColorBook.canvas.edgesIgnoringSafeArea(.all)
///
///                 VSheet()
///
///                 VPlainButton(
///                     action: { isActive = true },
///                     title: "Lorem ipsum"
///                 )
///             })
///                 .vNavigationLink(isActive: $isActive, destination: destination)
///         })
///     })
/// }
///
/// ```
///
public struct VNavigationLink<Destination, Content>: View
    where
        Destination: View,
        Content: View
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
    private let content: () -> Content
    
    // MARK: Initializers: Preset and Tap
    /// Initiales component with preset, destination and content
    public init(
        preset navLinkPreset: VNavigationLinkPreset,
        state: VNavigationLinkState = .enabled,
        destination: Destination,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.navLinkButtonType = navLinkPreset.buttonType
        self.state = state
        self._isActiveExternally = .constant(false)
        self.stateManagament = .internal
        self.destination = destination
        self.content = content
    }
    
    /// Initiales component with preset, destination and title
    public init(
        preset navLinkPreset: VNavigationLinkPreset,
        state: VNavigationLinkState = .enabled,
        destination: Destination,
        title: String
    )
        where Content == VText
    {
        self.init(
            preset: navLinkPreset,
            state: state,
            destination: destination,
            content: { navLinkPreset.text(from: title, isEnabled: state.isEnabled) }
        )
    }
    
    // MARK: Initializers: Preset and State
    /// Initiales component with preset, active state, destination and content
    public init(
        preset navLinkPreset: VNavigationLinkPreset,
        state: VNavigationLinkState = .enabled,
        isActive: Binding<Bool>,
        destination: Destination,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.navLinkButtonType = navLinkPreset.buttonType
        self.state = state
        self._isActiveExternally = isActive
        self.stateManagament = .external
        self.destination = destination
        self.content = content
    }
    
    /// Initiales component with preset, active state, destination and title
    public init(
        preset navLinkPreset: VNavigationLinkPreset,
        state: VNavigationLinkState = .enabled,
        isActive: Binding<Bool>,
        destination: Destination,
        title: String
    )
        where Content == VText
    {
        self.init(
            preset: navLinkPreset,
            state: state,
            isActive: isActive,
            destination: destination,
            content: { navLinkPreset.text(from: title, isEnabled: state.isEnabled) }
        )
    }
    
    // MARK: Initializers: Custom and Tap
    /// Initiales component with destination and content
    public init(
        state: VNavigationLinkState = .enabled,
        destination: Destination,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.navLinkButtonType = .custom
        self.state = state
        self._isActiveExternally = .constant(false)
        self.stateManagament = .internal
        self.destination = destination
        self.content = content
    }
    
    // MARK: Initializers: Custom and State
    /// Initiales component with destination, active state, and content
    public init(
        state: VNavigationLinkState = .enabled,
        isActive: Binding<Bool>,
        destination: Destination,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.navLinkButtonType = .custom
        self.state = state
        self._isActiveExternally = isActive
        self.stateManagament = .external
        self.destination = destination
        self.content = content
    }
}

// MARK:- Body
extension VNavigationLink {
    public var body: some View {
        contentView(isActive: isActive)
            .background({
                NavigationLink(destination: destinationView, isActive: isActive, label: { EmptyView() })
                    .allowsHitTesting(false)
                    .opacity(0)
            }())
    }
    
    private func contentView(isActive: Binding<Bool>) -> some View {
        VNavigationLinkType.navLinkButton(
            buttonType: navLinkButtonType,
            isEnabled: state.isEnabled,
            action: { isActive.wrappedValue = true },
            content: content
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
