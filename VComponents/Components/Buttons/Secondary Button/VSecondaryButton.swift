//
//  VSecondaryButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK: - V Secondary Button
/// Small colored button component that performs action when triggered.
///
/// Component can be initialized with title, icon and title, and content.
///
/// Model can be passed as parameter.
///
/// Usage example:
///
///     var body: some View {
///         VSecondaryButton(
///             action: { print("Clicked") },
///             title: "Lorem Ipsum"
///         )
///     }
///     
public struct VSecondaryButton<Content>: View where Content: View {
    // MARK: Properties
    private let model: VSecondaryButtonModel
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    @State private var isPressed: Bool = false
    private var internalState: VSecondaryButtonInternalState { .init(isEnabled: isEnabled, isPressed: isPressed) }
    
    private let action: () -> Void
    
    private let content: VSecondaryButtonContent<Content>

    // MARK: Initializers
    /// Initializes component with action and title.
    public init(
        model: VSecondaryButtonModel = .init(),
        action: @escaping () -> Void,
        title: String
    )
        where Content == Never
    {
        self.model = model
        self.action = action
        self.content = .title(title: title)
    }
    
    /// Initializes component with action, icon, and title.
    public init(
        model: VSecondaryButtonModel = .init(),
        action: @escaping () -> Void,
        icon: Image,
        title: String
    )
        where Content == Never
    {
        self.model = model
        self.action = action
        self.content = .iconTitle(icon: icon, title: title)
    }
    
    /// Initializes component with action and content.
    public init(
        model: VSecondaryButtonModel = .init(),
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
                .frame(height: model.layout.height)
                .background(background)
                .overlay(border)
                .padding(.horizontal, model.layout.hitBox.horizontal)
                .padding(.vertical, model.layout.hitBox.vertical)
        })
            .disabled(!internalState.isEnabled)
    }
    
    private var buttonContent: some View {
        Group(content: {
            switch content {
            case .title(let title):
                VText(
                    color: model.colors.title.for(internalState),
                    font: model.fonts.title,
                    title: title
                )
                
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
        })
            .padding(.horizontal, model.layout.contentMargins.horizontal)
            .padding(.vertical, model.layout.contentMargins.vertical)
    }
    
    private var background: some View {
        RoundedRectangle(cornerRadius: model.layout.cornerRadius)
            .foregroundColor(model.colors.background.for(internalState))
    }
    
    @ViewBuilder private var border: some View {
        if model.layout.hasBorder {
            RoundedRectangle(cornerRadius: model.layout.cornerRadius)
                .strokeBorder(model.colors.border.for(internalState), lineWidth: model.layout.borderWidth)
        }
    }

    // MARK: Actions
    private func gestureHandler(gestureState: VBaseButtonGestureState) {
        isPressed = gestureState.isPressed
        if gestureState.isClicked { action() }
    }
}

// MARK: - Preview
struct VSecondaryButton_Previews: PreviewProvider {
    static var previews: some View {
        VSecondaryButton(
            action: {},
            title: "Lorem Ipsum"
        )
            .padding()
    }
}