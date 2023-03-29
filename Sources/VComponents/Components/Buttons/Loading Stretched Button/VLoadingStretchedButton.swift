//
//  VLoadingStretchedButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VCore

// MARK: - V Loading Stretched Button
/// Large colored button component that performs action when triggered.
///
/// Component can be initialized with title, icon and title, and label.
///
/// UI Model and `isLoading` can be passed as parameters.
///
///     var body: some View {
///         VLoadingStretchedButton(
///             action: { print("Clicked") },
///             title: "Lorem Ipsum"
///         )
///             .padding()
///     }
///
@available(macOS, unavailable) // Doesn't follow Human Interface Guidelines
@available(tvOS, unavailable) // Doesn't follow Human Interface Guidelines. No `SwiftUIBaseButton` support.
@available(watchOS, unavailable) // Doesn't follow Human Interface Guidelines. No `SwiftUIBaseButton` support.
public struct VLoadingStretchedButton<Label>: View where Label: View {
    // MARK: Properties
    private let uiModel: VLoadingStretchedButtonUIModel
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    @State private var isPressed: Bool = false
    private let isLoading: Bool
    private var internalState: VLoadingStretchedButtonInternalState { .init(isEnabled: isEnabled, isPressed: isPressed, isLoading: isLoading) }
    
    private let action: () -> Void
    
    private let label: VLoadingStretchedButtonLabel<Label>
    
    private var hasBorder: Bool { uiModel.layout.borderWidth > 0 }
    
    // MARK: Initializers
    /// Initializes `VLoadingStretchedButton` with loading state, action, and title.
    public init(
        uiModel: VLoadingStretchedButtonUIModel = .init(),
        isLoading: Bool,
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
    
    /// Initializes `VLoadingStretchedButton` with loading state, action, icon, and title.
    public init(
        uiModel: VLoadingStretchedButtonUIModel = .init(),
        isLoading: Bool,
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
    
    /// Initializes `VLoadingStretchedButton` with loading state, action, and label.
    public init(
        uiModel: VLoadingStretchedButtonUIModel = .init(),
        isLoading: Bool,
        action: @escaping () -> Void,
        @ViewBuilder label: @escaping (VLoadingStretchedButtonInternalState) -> Label
    ) {
        self.uiModel = uiModel
        self.isLoading = isLoading
        self.action = action
        self.label = .label(label: label)
    }
    
    // MARK: Body
    public var body: some View {
        SwiftUIBaseButton(onStateChange: stateChangeHandler, label: {
            buttonLabel
                .frame(height: uiModel.layout.height)
                .background(background)
                .overlay(border)
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
                    
                case .label(let label):
                    label(internalState)
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
    private func stateChangeHandler(gestureState: BaseButtonGestureState) {
        isPressed = gestureState.isPressed
        if gestureState.isClicked { action() }
    }
}

// MARK: - Preview
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct VLoadingStretchedButton_Previews: PreviewProvider {
    // Configuration
    private static var colorScheme: ColorScheme { .light }
    
    // Previews
    static var previews: some View {
        Group(content: {
            Preview().previewDisplayName("*")
            StatesPreview().previewDisplayName("States")
        })
            .colorScheme(colorScheme)
    }
    
    // Data
    private static var title: String { "Lorem Ipsum" }
    
    // Previews (Scenes)
    private struct Preview: View {
        var body: some View {
            PreviewContainer(content: {
                VLoadingStretchedButton(
                    isLoading: false,
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
                        VLoadingStretchedButton(
                            isLoading: false,
                            action: {},
                            title: title
                        )
                    }
                )
                
                PreviewRow(
                    axis: .vertical,
                    title: "Pressed",
                    content: {
                        VLoadingStretchedButton(
                            uiModel: {
                                var uiModel: VLoadingStretchedButtonUIModel = .init()
                                uiModel.colors.background.enabled = uiModel.colors.background.pressed
                                uiModel.colors.title.enabled = uiModel.colors.title.pressed
                                return uiModel
                            }(),
                            isLoading: false,
                            action: {},
                            title: title
                        )
                    }
                )
                
                PreviewRow(
                    axis: .vertical,
                    title: "Loading",
                    content: {
                        VLoadingStretchedButton(
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
                        VLoadingStretchedButton(
                            isLoading: false,
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
