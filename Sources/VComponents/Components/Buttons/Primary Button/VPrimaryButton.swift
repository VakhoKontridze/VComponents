//
//  VPrimaryButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VCore

// MARK: - V Primary Button
/// Large colored button component that performs action when triggered.
///
/// Component can be initialized with title, icon and title, and label.
///
/// UI Model can be passed as parameter.
///
/// `isLoading` can be passed as parameter.
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
    private let uiModel: VPrimaryButtonUIModel
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    @State private var isPressed: Bool = false
    private let isLoading: Bool
    private var internalState: VPrimaryButtonInternalState { .init(isEnabled: isEnabled, isPressed: isPressed, isLoading: isLoading) }
    
    private let action: () -> Void
    
    private let label: VPrimaryButtonLabel<Label>
    
    private var hasBorder: Bool { uiModel.layout.borderWidth > 0 }
    
    // MARK: Initializers
    /// Initializes `VPrimaryButton` with action and title.
    public init(
        uiModel: VPrimaryButtonUIModel = .init(),
        isLoading: Bool = false,
        action: @escaping () -> Void,
        title: String
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self.isLoading = isLoading
        self.action = action
        self.label = .title(title: title)
    }
    
    /// Initializes `VPrimaryButton` with action, icon, and title.
    public init(
        uiModel: VPrimaryButtonUIModel = .init(),
        isLoading: Bool = false,
        action: @escaping () -> Void,
        icon: Image,
        title: String
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self.isLoading = isLoading
        self.action = action
        self.label = .iconTitle(icon: icon, title: title)
    }
    
    /// Initializes `VPrimaryButton` with action and label.
    public init(
        uiModel: VPrimaryButtonUIModel = .init(),
        isLoading: Bool = false,
        action: @escaping () -> Void,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.uiModel = uiModel
        self.isLoading = isLoading
        self.action = action
        self.label = .custom(label: label)
    }
    
    // MARK: Body
    public var body: some View {
        SwiftUIBaseButton(gesture: gestureHandler, label: {
            buttonLabel
                .frame(height: uiModel.layout.height)
                .background(content: { background })
                .overlay(content: { border })
        })
            .disabled(!internalState.isEnabled)
    }
    
    private var buttonLabel: some View {
        HStack(spacing: uiModel.layout.labelSpinnerSpacing, content: {
            spinnerCompensator

            Group(content: {
                switch label {
                case .title(let title):
                    labelTitleComponent(title: title)
                    
                case .iconTitle(let icon, let title):
                    HStack(spacing: uiModel.layout.iconTitleSpacing, content: {
                        labelIconComponent(icon: icon)
                        labelTitleComponent(title: title)
                    })
                    
                case .custom(let label):
                    label()
                        .opacity(uiModel.colors.customLabelOpacities.value(for: internalState))
                }
            })
                .frame(maxWidth: .infinity)

            spinner
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
    
    @ViewBuilder private var spinnerCompensator: some View {
        if internalState == .loading {
            Spacer()
                .frame(width: uiModel.layout.spinnerSubUIModel.dimension)
        }
    }
    
    @ViewBuilder private var spinner: some View {
        if internalState == .loading {
            VContinuousSpinner(uiModel: uiModel.spinnerSubUIModel)
        }
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
    private func gestureHandler(gestureState: BaseButtonGestureState) {
        isPressed = gestureState.isPressed
        if gestureState.isClicked { action() }
    }
}

// MARK: - Preview
struct VPrimaryButton_Previews: PreviewProvider {
    private static var title: String { "Lorem Ipsum" }
    
    static var previews: some View {
        ColorSchemePreview(title: nil, content: Preview.init)
        ColorSchemePreview(title: "States", content: StatesPreview.init)
    }
    
    private struct Preview: View {
        var body: some View {
            PreviewContainer(content: {
                VPrimaryButton(
                    action: { print("Clicked") },
                    title: title
                )
                .padding()
            })
        }
    }
    
    private struct StatesPreview: View {
        var body: some View {
            PreviewContainer(content: {
                PreviewRow(
                    axis: .vertical,
                    title: "Enabled",
                    content: {
                        VPrimaryButton(
                            action: {},
                            title: title
                        )
                    }
                )
                
                PreviewRow(
                    axis: .vertical,
                    title: "Pressed",
                    content: {
                        VPrimaryButton(
                            uiModel: {
                                var uiModel: VPrimaryButtonUIModel = .init()
                                uiModel.colors.background.enabled = uiModel.colors.background.pressed
                                uiModel.colors.title.enabled = uiModel.colors.title.pressed
                                return uiModel
                            }(),
                            action: {},
                            title: title
                        )
                    }
                )
                
                PreviewRow(
                    axis: .vertical,
                    title: "Loading",
                    content: {
                        VPrimaryButton(
                            isLoading: true,
                            action: {},
                            title: title
                        )
                    }
                )
                
                PreviewRow(
                    axis: .vertical,
                    title: "Disabled",
                    content: {
                        VPrimaryButton(
                            action: {},
                            title: title
                        )
                            .disabled(true)
                    }
                )
            })
        }
    }
}
