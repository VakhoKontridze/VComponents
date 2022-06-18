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
/// Component can be initialized with title, icon and title, and label.
///
/// UI Model can be passed as parameter.
///
///     var body: some View {
///         VSecondaryButton(
///             action: { print("Clicked") },
///             title: "Lorem Ipsum"
///         )
///     }
///     
public struct VSecondaryButton<Label>: View where Label: View {
    // MARK: Properties
    private let uiModel: VSecondaryButtonUIModel
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    @State private var isPressed: Bool = false
    private var internalState: VSecondaryButtonInternalState { .init(isEnabled: isEnabled, isPressed: isPressed) }
    
    private let action: () -> Void
    
    private let label: VSecondaryButtonLabel<Label>
    
    private var hasBorder: Bool { uiModel.layout.borderWidth > 0 }

    // MARK: Initializers
    /// Initializes component with action and title.
    public init(
        uiModel: VSecondaryButtonUIModel = .init(),
        action: @escaping () -> Void,
        title: String
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self.action = action
        self.label = .title(title: title)
    }
    
    /// Initializes component with action, icon, and title.
    public init(
        uiModel: VSecondaryButtonUIModel = .init(),
        action: @escaping () -> Void,
        icon: Image,
        title: String
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self.action = action
        self.label = .iconTitle(icon: icon, title: title)
    }
    
    /// Initializes component with action and label.
    public init(
        uiModel: VSecondaryButtonUIModel = .init(),
        action: @escaping () -> Void,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.uiModel = uiModel
        self.action = action
        self.label = .custom(label: label)
    }

    // MARK: Body
    public var body: some View {
        VBaseButton(gesture: gestureHandler, label: {
            buttonLabel
                .frame(height: uiModel.layout.height)
                .background(background)
                .overlay(border)
                .padding(uiModel.layout.hitBox)
        })
            .disabled(!internalState.isEnabled)
    }
    
    private var buttonLabel: some View {
        Group(content: {
            switch label {
            case .title(let title):
                VText(
                    color: uiModel.colors.title.for(internalState),
                    font: uiModel.fonts.title,
                    text: title
                )
                
            case .iconTitle(let icon, let title):
                HStack(spacing: uiModel.layout.iconTitleSpacing, content: {
                    icon
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(size: uiModel.layout.iconSize)
                        .foregroundColor(uiModel.colors.icon.for(internalState))
                        .opacity(uiModel.colors.iconOpacities.for(internalState))
                    
                    VText(
                        color: uiModel.colors.title.for(internalState),
                        font: uiModel.fonts.title,
                        text: title
                    )
                })
                
            case .custom(let label):
                label()
                    .opacity(uiModel.colors.customLabelOpacities.for(internalState))
            }
        })
            .padding(uiModel.layout.labelMargins)
    }
    
    private var background: some View {
        RoundedRectangle(cornerRadius: uiModel.layout.cornerRadius)
            .foregroundColor(uiModel.colors.background.for(internalState))
    }
    
    @ViewBuilder private var border: some View {
        if hasBorder {
            RoundedRectangle(cornerRadius: uiModel.layout.cornerRadius)
                .strokeBorder(uiModel.colors.border.for(internalState), lineWidth: uiModel.layout.borderWidth)
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
