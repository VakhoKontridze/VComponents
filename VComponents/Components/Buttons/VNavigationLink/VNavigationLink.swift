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
/// Component can be initialized with content or title. Component supports presets or existing button types.
///
/// State can be passed as parameter
///
/// # Usage Example #
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
    private let triggerType: TriggerType
    private enum TriggerType {
        case tap
        case state
    }
    
    private let linkType: VNavigationLinkType
    
    @State private var isActiveByTap: Bool = false  // Managed internally
    @Binding private var isActiveByState: Bool      // Binds to presenter view
    
    private let state: VNavigationLinkState
    
    private let destination: Destination
    private let label: () -> Label
    
    // MARK: Initializers
    public init(
        preset linkPreset: VNavigationLinkPreset,
        state: VNavigationLinkState = .enabled,
        destination: Destination,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.triggerType = .tap
        self.linkType = linkPreset.linkType
        self.state = state
        self._isActiveByState = .constant(false)
        self.destination = destination
        self.label = label
    }
    
    public init(
        preset linkPreset: VNavigationLinkPreset,
        isActive: Binding<Bool>,
        state: VNavigationLinkState = .enabled,
        destination: Destination,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.triggerType = .state
        self.linkType = linkPreset.linkType
        self.state = state
        self._isActiveByState = isActive
        self.destination = destination
        self.label = label
    }
    
    public init(
        preset linkPreset: VNavigationLinkPreset,
        state: VNavigationLinkState = .enabled,
        destination: Destination,
        title: String
    )
        where Label == VText
    {
        self.init(
            preset: linkPreset,
            state: state,
            destination: destination,
            label: { linkPreset.text(from: title, isEnabled: state.isEnabled) }
        )
    }
    
    public init(
        preset linkPreset: VNavigationLinkPreset,
        isActive: Binding<Bool>,
        state: VNavigationLinkState = .enabled,
        destination: Destination,
        title: String
    )
        where Label == VText
    {
        self.init(
            preset: linkPreset,
            isActive: isActive,
            state: state,
            destination: destination,
            label: { linkPreset.text(from: title, isEnabled: state.isEnabled) }
        )
    }
    
    public init(
        state: VNavigationLinkState = .enabled,
        destination: Destination,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.triggerType = .tap
        self.linkType = .custom
        self.state = state
        self._isActiveByState = .constant(false)
        self.destination = destination
        self.label = label
    }
    
    public init(
        isActive: Binding<Bool>,
        state: VNavigationLinkState = .enabled,
        destination: Destination,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.triggerType = .state
        self.linkType = .custom
        self.state = state
        self._isActiveByState = isActive
        self.destination = destination
        self.label = label
    }
}

// MARK:- Body
extension VNavigationLink {
    @ViewBuilder public var body: some View {
        switch triggerType {
        case .tap: contentView(isActive: $isActiveByTap)
        case .state: contentView(isActive: $isActiveByState)
        }
    }
    
    private func contentView(isActive: Binding<Bool>) -> some View {
        labelView(isActive: isActive)
            .background({
                NavigationLink(destination: destinationView, isActive: isActive, label: { EmptyView() })
                    .allowsHitTesting(false)
                    .opacity(0)
            }())
    }
    
    @ViewBuilder private func labelView(isActive: Binding<Bool>) -> some View {
        switch linkType {
        case .primary(let model):
            VPrimaryButton(
                model: model,
                state: state.isEnabled ? .enabled : .disabled,
                action: { isActive.wrappedValue = true },
                content: label
            )
            
        case .secondary(let model):
            VSecondaryButton(
                model: model,
                state: state.isEnabled ? .enabled : .disabled,
                action: { isActive.wrappedValue = true },
                content: label
            )
            
        case .square(let model):
            VSquareButton(
                model: model,
                state: state.isEnabled ? .enabled : .disabled,
                action: { isActive.wrappedValue = true },
                content: label
            )
            
        case .plain(let model):
            VPlainButton(
                model: model,
                state: state.isEnabled ? .enabled : .disabled,
                action: { isActive.wrappedValue = true },
                content: label
            )
            
        case .custom:
            label()
                .allowsHitTesting(state.isEnabled)
                .onTapGesture(perform: { isActive.wrappedValue = true })
        }
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
