//
//  VLoadingStretchedButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VCore

// MARK: - V Loading Stretched Button
/// Stretched button component that indicates loading activity, and performs action when triggered.
///
///     var body: some View {
///         VLoadingStretchedButton(
///             isLoading: false,
///             action: { print("Clicked") },
///             title: "Lorem Ipsum"
///         )
///         .padding(.horizontal)
///     }
///
/// On `macOS`, an explicit width should be provided.
@available(tvOS, unavailable) // Doesn't follow HIG
@available(watchOS, unavailable) // Doesn't follow HIG
@available(visionOS, unavailable) // Doesn't follow HIG
public struct VLoadingStretchedButton<CustomLabel>: View where CustomLabel: View {
    // MARK: Properties - UI Model
    private let uiModel: VLoadingStretchedButtonUIModel

    @Environment(\.displayScale) private var displayScale: CGFloat

    // MARK: Properties - State
    @Environment(\.isEnabled) private var isEnabled: Bool
    private let isLoading: Bool
    private func internalState(_ baseButtonState: SwiftUIBaseButtonState) -> VLoadingStretchedButtonInternalState {
        .init(
            isEnabled: isEnabled,
            isPressed: baseButtonState == .pressed,
            isLoading: isLoading
        )
    }

    // MARK: Properties - Action
    private let action: () -> Void

    // MARK: Properties - Label
    private let label: VLoadingStretchedButtonLabel<CustomLabel>

    // MARK: Initializers
    /// Initializes `VLoadingStretchedButton` with loading state, action, and title.
    public init(
        uiModel: VLoadingStretchedButtonUIModel = .init(),
        isLoading: Bool,
        action: @escaping () -> Void,
        title: String
    )
        where CustomLabel == Never
    {
        self.uiModel = uiModel
        self.isLoading = isLoading
        self.action = action
        self.label = .title(title: title)
    }

    /// Initializes `VLoadingStretchedButton` with loading state, action, and icon.
    public init(
        uiModel: VLoadingStretchedButtonUIModel = .init(),
        isLoading: Bool,
        action: @escaping () -> Void,
        icon: Image
    )
        where CustomLabel == Never
    {
        self.uiModel = uiModel
        self.isLoading = isLoading
        self.action = action
        self.label = .icon(icon: icon)
    }

    /// Initializes `VLoadingStretchedButton` with loading state, action, icon, and title.
    public init(
        uiModel: VLoadingStretchedButtonUIModel = .init(),
        isLoading: Bool,
        action: @escaping () -> Void,
        title: String,
        icon: Image
    )
        where CustomLabel == Never
    {
        self.uiModel = uiModel
        self.isLoading = isLoading
        self.action = action
        self.label = .titleAndIcon(title: title, icon: icon)
    }
    
    /// Initializes `VLoadingStretchedButton` with loading state, action, and custom label.
    public init(
        uiModel: VLoadingStretchedButtonUIModel = .init(),
        isLoading: Bool,
        action: @escaping () -> Void,
        @ViewBuilder label customLabel: @escaping (VLoadingStretchedButtonInternalState) -> CustomLabel
    ) {
        self.uiModel = uiModel
        self.isLoading = isLoading
        self.action = action
        self.label = .custom(custom: customLabel)
    }
    
    // MARK: Body
    public var body: some View {
        SwiftUIBaseButton(
            uiModel: uiModel.baseButtonSubUIModel,
            action: {
                playHapticEffect()
                action()
            },
            label: { baseButtonState in
                let internalState: VLoadingStretchedButtonInternalState = internalState(baseButtonState)
                
                labelView(internalState: internalState)
                    .contentShape(.rect) // Registers gestures even when clear
                    .frame(height: uiModel.height)
                    .background { backgroundView(internalState: internalState) }
                    .overlay { borderView(internalState: internalState) }
                    .clipShape(.rect(cornerRadius: uiModel.cornerRadius))
            }
        )
        .disabled(isLoading)
    }
    
    private func labelView(
        internalState: VLoadingStretchedButtonInternalState
    ) -> some View {
        HStack(spacing: uiModel.labelAndSpinnerSpacing) {
            spinnerCompensatorView(internalState: internalState)

            Group {
                switch label {
                case .title(let title):
                    titleLabelViewComponent(internalState: internalState, title: title)

                case .icon(let icon):
                    iconLabelViewComponent(internalState: internalState, icon: icon)

                case .titleAndIcon(let title, let icon):
                    switch uiModel.titleTextAndIconPlacement {
                    case .titleAndIcon:
                        HStack(spacing: uiModel.titleTextAndIconSpacing) {
                            titleLabelViewComponent(internalState: internalState, title: title)
                            iconLabelViewComponent(internalState: internalState, icon: icon)
                        }

                    case .iconAndTitle:
                        HStack(spacing: uiModel.titleTextAndIconSpacing) {
                            iconLabelViewComponent(internalState: internalState, icon: icon)
                            titleLabelViewComponent(internalState: internalState, title: title)
                        }
                    }

                case .custom(let custom):
                    custom(internalState)
                }
            }
            .frame(maxWidth: .infinity)
            
            spinnerView(internalState: internalState)
        }
        .scaleEffect(internalState == .pressed ? uiModel.labelPressedScale : 1)
        .padding(uiModel.labelMargins)
    }
    
    private func titleLabelViewComponent(
        internalState: VLoadingStretchedButtonInternalState,
        title: String
    ) -> some View {
        Text(title)
            .lineLimit(1)
            .minimumScaleFactor(uiModel.titleTextMinimumScaleFactor)
            .foregroundStyle(uiModel.titleTextColors.value(for: internalState))
            .font(uiModel.titleTextFont)
            .applyIfLet(uiModel.titleTextDynamicTypeSizeType) { $0.dynamicTypeSize(type: $1) }
    }
    
    private func iconLabelViewComponent(
        internalState: VLoadingStretchedButtonInternalState,
        icon: Image
    ) -> some View {
        icon
            .applyIf(uiModel.isIconResizable) { $0.resizable() }
            .applyIfLet(uiModel.iconContentMode) { $0.aspectRatio(nil, contentMode: $1) }
            .applyIfLet(uiModel.iconColors) { $0.foregroundStyle($1.value(for: internalState)) }
            .applyIfLet(uiModel.iconOpacities) { $0.opacity($1.value(for: internalState)) }
            .font(uiModel.iconFont)
            .applyIfLet(uiModel.iconDynamicTypeSizeType) { $0.dynamicTypeSize(type: $1) }
            .frame(size: uiModel.iconSize)
    }
    
    @ViewBuilder 
    private func spinnerCompensatorView(
        internalState: VLoadingStretchedButtonInternalState
    ) -> some View {
        if internalState == .loading {
            Spacer()
                .frame(width: uiModel.spinnerSubUIModel.dimension)
        }
    }
    
    @ViewBuilder 
    private func spinnerView(
        internalState: VLoadingStretchedButtonInternalState
    ) -> some View {
        if internalState == .loading {
            VContinuousSpinner(uiModel: uiModel.spinnerSubUIModel)
        }
    }
    
    private func backgroundView(
        internalState: VLoadingStretchedButtonInternalState
    ) -> some View {
        Rectangle()
            .scaleEffect(internalState == .pressed ? uiModel.backgroundPressedScale : 1)
            .foregroundStyle(uiModel.backgroundColors.value(for: internalState))
            .shadow(
                color: uiModel.shadowColors.value(for: internalState),
                radius: uiModel.shadowRadius,
                offset: uiModel.shadowOffset
            )
    }
    
    @ViewBuilder 
    private func borderView(
        internalState: VLoadingStretchedButtonInternalState
    ) -> some View {
        let borderWidth: CGFloat = uiModel.borderWidth.toPoints(scale: displayScale)

        if borderWidth > 0 {
            RoundedRectangle(cornerRadius: uiModel.cornerRadius)
                .strokeBorder(uiModel.borderColors.value(for: internalState), lineWidth: borderWidth)
                .scaleEffect(internalState == .pressed ? uiModel.backgroundPressedScale : 1)
        }
    }
    
    // MARK: Haptics
    private func playHapticEffect() {
#if os(iOS)
        HapticManager.shared.playImpact(uiModel.haptic)
#endif
    }
}

// MARK: - Preview
#if DEBUG

#if !(os(tvOS) || os(watchOS) || os(visionOS)) // Redundant

#Preview("*") {
    PreviewContainer {
        VLoadingStretchedButton(
            isLoading: false,
            action: {},
            title: "Lorem Ipsum"
        )
        .modifier(Preview_StretchedButtonFrameModifier())
    }
}

#Preview("States") {
    PreviewContainer {
        PreviewRow("Enabled") {
            VLoadingStretchedButton(
                isLoading: false,
                action: {},
                title: "Lorem Ipsum"
            )
            .modifier(Preview_StretchedButtonFrameModifier())
        }

        PreviewRow("Pressed") {
            VLoadingStretchedButton(
                uiModel: {
                    var uiModel: VLoadingStretchedButtonUIModel = .init()
                    uiModel.backgroundColors.enabled = uiModel.backgroundColors.pressed
                    uiModel.titleTextColors.enabled = uiModel.titleTextColors.pressed
                    return uiModel
                }(),
                isLoading: false,
                action: {},
                title: "Lorem Ipsum"
            )
            .modifier(Preview_StretchedButtonFrameModifier())
        }

        PreviewRow("Loading") {
            VLoadingStretchedButton(
                isLoading: true,
                action: {},
                title: "Lorem Ipsum"
            )
            .modifier(Preview_StretchedButtonFrameModifier())
        }

        PreviewRow("Disabled") {
            VLoadingStretchedButton(
                isLoading: false,
                action: {},
                title: "Lorem Ipsum"
            )
            .modifier(Preview_StretchedButtonFrameModifier())
            .disabled(true)
        }
    }
}

#endif

#endif
