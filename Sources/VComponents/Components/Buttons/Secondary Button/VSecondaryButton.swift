//
//  VSecondaryButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI
import VCore

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
@available(macOS, unavailable) // No `SwiftUIBaseButton` support
@available(tvOS, unavailable) // No `SwiftUIBaseButton` support
@available(watchOS, unavailable) // No `SwiftUIBaseButton` support
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
    /// Initializes `VSecondaryButton` with action and title.
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
    
    /// Initializes `VSecondaryButton` with action, icon, and title.
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
    
    /// Initializes `VSecondaryButton` with action and label.
    public init(
        uiModel: VSecondaryButtonUIModel = .init(),
        action: @escaping () -> Void,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.uiModel = uiModel
        self.action = action
        self.label = .content(content: label)
    }

    // MARK: Body
    public var body: some View {
        SwiftUIBaseButton(onStateChange: stateChangeHandler, label: {
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
                labelTitleComponent(title: title)
                
            case .iconTitle(let icon, let title):
                HStack(spacing: uiModel.layout.iconTitleSpacing, content: {
                    labelIconComponent(icon: icon)
                    labelTitleComponent(title: title)
                })
                
            case .content(let label):
                label()
                    .opacity(uiModel.colors.customLabelOpacities.value(for: internalState))
            }
        })
            .padding(uiModel.layout.labelMargins)
    }
    
    private func labelTitleComponent(title: String) -> some View {
        VText(
            minimumScaleFactor: uiModel.layout.titleMinimumScaleFactor,
            color: uiModel.colors.title.value(for: internalState),
            font: uiModel.fonts.title,
            text: title
        )
    }
    
    private func labelIconComponent(icon: Image) -> some View {
        icon
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(size: uiModel.layout.iconSize)
            .foregroundColor(uiModel.colors.icon.value(for: internalState))
            .opacity(uiModel.colors.iconOpacities.value(for: internalState))
    }
    
    private var background: some View {
        RoundedRectangle(cornerRadius: uiModel.layout.cornerRadius)
            .foregroundColor(uiModel.colors.background.value(for: internalState))
    }
    
    @ViewBuilder private var border: some View {
        if hasBorder {
            RoundedRectangle(cornerRadius: uiModel.layout.cornerRadius)
                .strokeBorder(uiModel.colors.border.value(for: internalState), lineWidth: uiModel.layout.borderWidth)
        }
    }

    // MARK: Actions
    private func stateChangeHandler(gestureState: BaseButtonGestureState) {
        isPressed = gestureState.isPressed
        if gestureState.isClicked { action() }
    }
}

// MARK: - Preview
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct VSecondaryButton_Previews: PreviewProvider {
    static var previews: some View {
        ColorSchemePreview(title: nil, content: Preview.init)
        ColorSchemePreview(title: "States", content: StatesPreview.init)
    }
    
    private struct Preview: View {
        var body: some View {
            PreviewContainer(content: {
                VSecondaryButton(
                    action: { print("Clicked") },
                    title: "Lorem Ipsum"
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
                        VSecondaryButton(
                            action: {},
                            title: "Lorem Ipsum"
                        )
                    }
                )
                
                PreviewRow(
                    axis: .horizontal,
                    title: "Pressed",
                    content: {
                        VSecondaryButton(
                            uiModel: {
                                var uiModel: VSecondaryButtonUIModel = .init()
                                uiModel.colors.background.enabled = uiModel.colors.background.pressed
                                uiModel.colors.title.enabled = uiModel.colors.title.pressed
                                return uiModel
                            }(),
                            action: {},
                            title: "Lorem Ipsum"
                        )
                    }
                )
                
                PreviewRow(
                    axis: .horizontal,
                    title: "Disabled",
                    content: {
                        VSecondaryButton(
                            action: {},
                            title: "Lorem Ipsum"
                        )
                            .disabled(true)
                    }
                )
            })
        }
    }
}
