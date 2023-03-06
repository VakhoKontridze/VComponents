//
//  VRoundedLabeledButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 17.08.22.
//

import SwiftUI
import VCore

// MARK: - V Rounded Labeled Button
/// Rounded colored labeled button component that performs action when triggered.
///
/// Component can be initialized with title, icon and title, and label.
///
/// UI Model can be passed as parameter.
///
///     var body: some View {
///         VRoundedLabeledButton(
///             action: { print("Clicked") },
///             icon: .init(systemName: "swift"),
///             titleLabel: "Lorem Ipsum"
///         )
///     }
///
public struct VRoundedLabeledButton<Label>: View where Label: View {
    // MARK: Properties
    private let uiModel: VRoundedLabeledButtonUIModel
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    @State private var isPressed: Bool = false
    private var internalState: VRoundedLabeledButtonInternalState { .init(isEnabled: isEnabled, isPressed: isPressed) }
    
    private let action: () -> Void
    
    private let icon: Image
    private let label: VRoundedLabeledButtonLabel<Label>
    
    private var hasBorder: Bool { uiModel.layout.borderWidth > 0 }
    
    // MARK: Initializers
    /// Initializes component with action, icon, and title label.
    public init(
        uiModel: VRoundedLabeledButtonUIModel = .init(),
        action: @escaping () -> Void,
        icon: Image,
        titleLabel: String
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self.action = action
        self.icon = icon
        self.label = .title(title: titleLabel)
    }
    
    /// Initializes component with action, icon, icon label, and title label.
    public init(
        uiModel: VRoundedLabeledButtonUIModel = .init(),
        action: @escaping () -> Void,
        icon: Image,
        iconLabel: Image,
        titleLabel: String
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self.action = action
        self.icon = icon
        self.label = .iconTitle(icon: iconLabel, title: titleLabel)
    }
    
    /// Initializes component with action, icon, and label.
    public init(
        uiModel: VRoundedLabeledButtonUIModel = .init(),
        action: @escaping () -> Void,
        icon: Image,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.uiModel = uiModel
        self.action = action
        self.icon = icon
        self.label = .custom(label: label)
    }
    
    // MARK: Body
    public var body: some View {
        SwiftUIBaseButton(gesture: gestureHandler, label: {
            VStack(spacing: uiModel.layout.rectangleLabelSpacing, content: {
                rectangle
                buttonLabel
            })
        })
            .disabled(!internalState.isEnabled)
    }
    
    private var rectangle: some View {
        Group(content: {
            icon
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(size: uiModel.layout.iconSize)
                .foregroundColor(uiModel.colors.icon.value(for: internalState))
                .opacity(uiModel.colors.iconOpacities.value(for: internalState))
        })
            .frame(dimension: uiModel.layout.roundedRectangleDimension)
            .background(content: { rectangleBackground })
            .overlay(content: { roundedRectangleBorder })
    }
    
    private var rectangleBackground: some View {
        RoundedRectangle(cornerRadius: uiModel.layout.cornerRadius)
            .foregroundColor(uiModel.colors.background.value(for: internalState))
    }
    
    @ViewBuilder private var roundedRectangleBorder: some View {
        if hasBorder {
            RoundedRectangle(cornerRadius: uiModel.layout.cornerRadius)
                .strokeBorder(uiModel.colors.border.value(for: internalState), lineWidth: uiModel.layout.borderWidth)
        }
    }
    
    private var buttonLabel: some View {
        Group(content: {
            switch label {
            case .title(let title):
                labelTitleComponent(title: title)
                
            case .iconTitle(let icon, let title):
                HStack(spacing: uiModel.layout.labelSpacing, content: {
                    labelIconComponent(icon: icon)
                    labelTitleComponent(title: title)
                })
                
            case .custom(let label):
                label()
                    .opacity(uiModel.colors.customLabelOpacities.value(for: internalState))
            }
        })
            .frame(maxWidth: uiModel.layout.labelWidthMax)
    }
    
    private func labelTitleComponent(title: String) -> some View {
        VText(
            type: uiModel.layout.titleLabelLineType,
            minimumScaleFactor: uiModel.layout.titleLabelMinimumScaleFactor,
            color: uiModel.colors.titleLabel.value(for: internalState),
            font: uiModel.fonts.titleLabel,
            text: title
        )
    }
    
    private func labelIconComponent(icon: Image) -> some View {
        icon
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(size: uiModel.layout.iconLabelSize)
            .foregroundColor(uiModel.colors.iconLabel.value(for: internalState))
            .opacity(uiModel.colors.iconLabelOpacities.value(for: internalState))
    }
    
    // MARK: Actions
    private func gestureHandler(gestureState: BaseButtonGestureState) {
        isPressed = gestureState.isPressed
        if gestureState.isClicked { action() }
    }
}

// MARK: - Preview
struct VRoundedLabeledButton_Previews: PreviewProvider {
    static var previews: some View {
        VRoundedLabeledButton(
            action: { print("Clicked") },
            icon: .init(systemName: "swift"),
            titleLabel: "Lorem Ipsum"
        )
    }
}
