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
@available(macOS, unavailable) // Doesn't follow Human Interface Guidelines
@available(tvOS, unavailable) // Doesn't follow Human Interface Guidelines. No `SwiftUIBaseButton` support.
@available(watchOS, unavailable) // Doesn't follow Human Interface Guidelines. No `SwiftUIBaseButton` support.
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
    /// Initializes `VRoundedLabeledButton` with action, icon, and title label.
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
    
    /// Initializes `VRoundedLabeledButton` with action, icon, icon label, and title label.
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
    
    /// Initializes `VRoundedLabeledButton` with action, icon, and label.
    public init(
        uiModel: VRoundedLabeledButtonUIModel = .init(),
        action: @escaping () -> Void,
        icon: Image,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.uiModel = uiModel
        self.action = action
        self.icon = icon
        self.label = .content(content: label)
    }
    
    // MARK: Body
    public var body: some View {
        SwiftUIBaseButton(onStateChange: stateChangeHandler, label: {
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
            .background(rectangleBackground)
            .overlay(roundedRectangleBorder)
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
                
            case .content(let label):
                label()
                    .opacity(uiModel.colors.customLabelOpacities.value(for: internalState))
            }
        })
            .frame(maxWidth: uiModel.layout.labelWidthMax)
    }
    
    private func labelTitleComponent(title: String) -> some View {
        VText(
            type: uiModel.layout.titleLabelTextLineType,
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
    private func stateChangeHandler(gestureState: BaseButtonGestureState) {
        isPressed = gestureState.isPressed
        if gestureState.isClicked { action() }
    }
}

// MARK: - Preview
@available(macOS 11.0, *)@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct VRoundedLabeledButton_Previews: PreviewProvider {
    private static var icon: Image { .init(systemName: "swift") }
    private static var titleLabel: String { "Lorem Ipsum" }
    
    static var previews: some View {
        ColorSchemePreview(title: nil, content: Preview.init)
        ColorSchemePreview(title: "States", content: StatesPreview.init)
    }
    
    private struct Preview: View {
        var body: some View {
            PreviewContainer(content: {
                VRoundedLabeledButton(
                    action: { print("Clicked") },
                    icon: icon,
                    titleLabel: titleLabel
                )
            })
        }
    }
    
    private struct StatesPreview: View {
        var body: some View {
            PreviewContainer(content: {
                PreviewRow(
                    axis: .horizontal,
                    title: "Enabled",
                    content: {
                        VRoundedLabeledButton(
                            action: {},
                            icon: icon,
                            titleLabel: titleLabel
                        )
                    }
                )
                
                PreviewRow(
                    axis: .horizontal,
                    title: "Pressed",
                    content: {
                        VRoundedLabeledButton(
                            uiModel: {
                                var uiModel: VRoundedLabeledButtonUIModel = .init()
                                uiModel.colors.background.enabled = uiModel.colors.background.pressed
                                uiModel.colors.icon.enabled = uiModel.colors.icon.pressed
                                uiModel.colors.titleLabel.enabled = uiModel.colors.titleLabel.pressed
                                return uiModel
                            }(),
                            action: {},
                            icon: icon,
                            titleLabel: titleLabel
                        )
                    }
                )
                
                PreviewRow(
                    axis: .horizontal,
                    title: "Disabled",
                    content: {
                        VRoundedLabeledButton(
                            action: {},
                            icon: icon,
                            titleLabel: titleLabel
                        )
                            .disabled(true)
                    }
                )
            })
        }
    }
}
