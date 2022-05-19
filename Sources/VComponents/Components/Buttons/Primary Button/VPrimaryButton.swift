//
//  VPrimaryButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK: - V Primary Button
/// Large colored button component that performs action when triggered.
///
/// Component can be initialized with title, icon and title, and label.
///
/// Model can be passed as parameter.
///
/// `isLoading` can be passed as paremter.
///
/// Usage example:
///
///     var body: some View {
///         VPrimaryButton(
///             action: { print("Clicked") },
///             title: "Lorem Ipsum"
///         )
///             .padding()
///     }
///
public struct VPrimaryButton<Label>: View where Label: View {
    // MARK: Properties
    private let model: VPrimaryButtonModel
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    @State private var isPressed: Bool = false
    private let isLoading: Bool
    private var internalState: VPrimaryButtonInternalState { .init(isEnabled: isEnabled, isPressed: isPressed, isLoading: isLoading) }
    
    private let action: () -> Void
    
    private let label: VPrimaryButtonLabel<Label>
    
    private var hasBorder: Bool { model.layout.borderWidth > 0 }
    
    // MARK: Initializers
    /// Initializes component with action and title.
    public init(
        model: VPrimaryButtonModel = .init(),
        isLoading: Bool = false,
        action: @escaping () -> Void,
        title: String
    )
        where Label == Never
    {
        self.model = model
        self.isLoading = isLoading
        self.action = action
        self.label = .title(title: title)
    }
    
    /// Initializes component with action, icon, and title.
    public init(
        model: VPrimaryButtonModel = .init(),
        isLoading: Bool = false,
        action: @escaping () -> Void,
        icon: Image,
        title: String
    )
        where Label == Never
    {
        self.model = model
        self.isLoading = isLoading
        self.action = action
        self.label = .iconTitle(icon: icon, title: title)
    }
    
    /// Initializes component with action and label.
    public init(
        model: VPrimaryButtonModel = .init(),
        isLoading: Bool = false,
        action: @escaping () -> Void,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.model = model
        self.isLoading = isLoading
        self.action = action
        self.label = .custom(label: label)
    }
    
    // MARK: Body
    public var body: some View {
        VBaseButton(gesture: gestureHandler, label: {
            buttonLabel
                .frame(height: model.layout.height)
                .background(background)
                .overlay(border)
        })
            .disabled(!internalState.isEnabled)
    }
    
    private var buttonLabel: some View {
        HStack(spacing: model.layout.labelLoaderSpacing, content: {
            loaderCompensator

            Group(content: {
                switch label {
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
                    
                case .custom(let label):
                    label()
                        .opacity(model.colors.customLabelOpacities.for(internalState))
                }
            })
                .frame(maxWidth: .infinity)

            loader
        })
            .padding(model.layout.labelMargins)
    }
    
    @ViewBuilder private var loaderCompensator: some View {
        if internalState.isLoading {
            Spacer()
                .frame(width: model.layout.loaderDimension)
        }
    }
    
    @ViewBuilder private var loader: some View {
        if internalState.isLoading {
            VSpinner(type: .continous(model.spinnerSubModel))
        }
    }
    
    private var background: some View {
        RoundedRectangle(cornerRadius: model.layout.cornerRadius)
            .foregroundColor(model.colors.background.for(internalState))
    }
    
    @ViewBuilder private var border: some View {
        if hasBorder {
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
struct VPrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        VPrimaryButton(
            action: {},
            title: "Lorem Ipsum"
        )
            .padding()
    }
}
