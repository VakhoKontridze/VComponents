//
//  VPlainButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK: - V Plain Button
/// Plain button component that performs action when triggered.
///
/// Component can be initialized with title, icon, icon and title, and content.
///
/// Model can be passed as parameter.
///
/// Usage example:
///
///     var body: some View {
///         VPlain(
///             action: { print("Clicked") },
///             title: "Lorem Ipsum"
///         )
///     }
///     
public struct VPlainButton<Content>: View where Content: View {
    // MARK: Properties
    private let model: VPlainButtonModel
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    @State private var isPressed: Bool = false
    private var internalState: VPlainButtonInternalState { .init(isEnabled: isEnabled, isPressed: isPressed) }
    
    private let action: () -> Void
    
    private let content: VPlainButtonContent<Content>

    // MARK: Initializers
    /// Initializes component with action and title.
    public init(
        model: VPlainButtonModel = .init(),
        action: @escaping () -> Void,
        title: String
    )
        where Content == Never
    {
        self.model = model
        self.action = action
        self.content = .title(title: title)
    }
    
    /// Initializes component with action and icon.
    public init(
        model: VPlainButtonModel = .init(),
        action: @escaping () -> Void,
        icon: Image
    )
        where Content == Never
    {
        self.model = model
        self.action = action
        self.content = .icon(icon: icon)
    }
    
    /// Initializes component with action, icon, and title.
    public init(
        model: VPlainButtonModel = .init(),
        action: @escaping () -> Void,
        icon: Image,
        title: String
    )
        where Content == Never
    {
        self.model = model
        self.action = action
        self.content = .iconTitle(icon: icon, text: title)
    }
    
    /// Initializes component with action and content.
    public init(
        model: VPlainButtonModel = .init(),
        action: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.model = model
        self.action = action
        self.content = .content(content: content)
    }

    // MARK: Body
    public var body: some View {
        VBaseButton(gesture: gestureHandler, content: {
            buttonContent
                .padding(.horizontal, model.layout.hitBox.horizontal)
                .padding(.vertical, model.layout.hitBox.vertical)
        })
            .disabled(!internalState.isEnabled)
    }
    
    @ViewBuilder private var buttonContent: some View {
        switch content {
        case .title(let title):
            VText(
                color: model.colors.title.for(internalState),
                font: model.fonts.title,
                title: title
            )
            
        case .icon(let icon):
            icon
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(size: model.layout.iconSize)
                .foregroundColor(model.colors.icon.for(internalState))
                .opacity(model.colors.iconOpacities.for(internalState))
            
        case .iconTitle(let icon, let title):
            HStack(spacing: model.layout.iconTitleSpacing, content: {
                icon
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(size: model.layout.iconSize)
                    .foregroundColor(model.colors.icon.for(internalState))
                    .opacity(model.colors.iconOpacities.for(internalState))
                
                VText(
                    color: model.colors.title.for(internalState),
                    font: model.fonts.title,
                    title: title
                )
            })
            
        case .content(let content):
            content()
                .opacity(model.colors.customContentOpacities.for(internalState))
        }
    }

    // MARK: Actions
    private func gestureHandler(gestureState: VBaseButtonGestureState) {
        isPressed = gestureState.isPressed
        if gestureState.isClicked { action() }
    }
}

// MARK: - Preview
struct VPlainButton_Previews: PreviewProvider {
    static var previews: some View {
        VPlainButton(action: {}, title: "Lorem Ipsum")
            .padding()
    }
}
