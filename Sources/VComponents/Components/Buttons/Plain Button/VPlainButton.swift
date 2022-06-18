//
//  VPlainButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VCore

// MARK: - V Plain Button
/// Plain button component that performs action when triggered.
///
/// Component can be initialized with title, icon, icon and title, and label.
///
/// UI Model can be passed as parameter.
///
///     var body: some View {
///         VPlain(
///             action: { print("Clicked") },
///             title: "Lorem Ipsum"
///         )
///     }
///     
public struct VPlainButton<Label>: View where Label: View {
    // MARK: Properties
    private let uiModel: VPlainButtonUIModel
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    @State private var isPressed: Bool = false
    private var internalState: VPlainButtonInternalState { .init(isEnabled: isEnabled, isPressed: isPressed) }
    
    private let action: () -> Void
    
    private let label: VPlainButtonLabel<Label>

    // MARK: Initializers
    /// Initializes component with action and title.
    public init(
        uiModel: VPlainButtonUIModel = .init(),
        action: @escaping () -> Void,
        title: String
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self.action = action
        self.label = .title(title: title)
    }
    
    /// Initializes component with action and icon.
    public init(
        uiModel: VPlainButtonUIModel = .init(),
        action: @escaping () -> Void,
        icon: Image
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self.action = action
        self.label = .icon(icon: icon)
    }
    
    /// Initializes component with action, icon, and title.
    public init(
        uiModel: VPlainButtonUIModel = .init(),
        action: @escaping () -> Void,
        icon: Image,
        title: String
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self.action = action
        self.label = .iconTitle(icon: icon, text: title)
    }
    
    /// Initializes component with action and label.
    public init(
        uiModel: VPlainButtonUIModel = .init(),
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
                .padding(uiModel.layout.hitBox)
        })
            .disabled(!internalState.isEnabled)
    }
    
    @ViewBuilder private var buttonLabel: some View {
        switch label {
        case .title(let title):
            VText(
                color: uiModel.colors.title.for(internalState),
                font: uiModel.fonts.title,
                text: title
            )
            
        case .icon(let icon):
            icon
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(size: uiModel.layout.iconSize)
                .foregroundColor(uiModel.colors.icon.for(internalState))
                .opacity(uiModel.colors.iconOpacities.for(internalState))
            
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
        VPlainButton(
            action: {},
            title: "Lorem Ipsum"
        )
            .padding()
    }
}
