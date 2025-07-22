//
//  VWrappedButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI
import VCore

// MARK: - V Wrapped Button
/// Wrapped button component that performs action when triggered.
///
///     var body: some View {
///         VWrappedButton(
///             action: { print("Clicked") },
///             title: "Lorem Ipsum"
///         )
///     }
///
@available(tvOS, unavailable) // Doesn't follow HIG
@available(visionOS, unavailable) // Doesn't follow HIG
public struct VWrappedButton<CustomLabel>: View where CustomLabel: View {
    // MARK: Properties - Appearance
    private let appearance: VWrappedButtonAppearance
    
    @Environment(\.displayScale) private var displayScale: CGFloat

    // MARK: Properties - State
    @Environment(\.isEnabled) private var isEnabled: Bool
    private func internalState(_ baseButtonState: SwiftUIBaseButtonState) -> VWrappedButtonInternalState {
        .init(
            isEnabled: isEnabled,
            isPressed: baseButtonState == .pressed
        )
    }

    // MARK: Properties - Action
    private let action: () -> Void

    // MARK: Properties - Label
    private let label: VWrappedButtonLabel<CustomLabel>

    // MARK: Initializers
    /// Initializes `VWrappedButton` with action and title.
    public init(
        appearance: VWrappedButtonAppearance = .init(),
        action: @escaping () -> Void,
        title: String
    )
        where CustomLabel == Never
    {
        self.appearance = appearance
        self.action = action
        self.label = .title(title: title)
    }

    /// Initializes `VWrappedButton` with action and icon.
    public init(
        appearance: VWrappedButtonAppearance = .init(),
        action: @escaping () -> Void,
        icon: Image
    )
        where CustomLabel == Never
    {
        self.appearance = appearance
        self.action = action
        self.label = .icon(icon: icon)
    }

    /// Initializes `VWrappedButton` with action, icon, and title.
    public init(
        appearance: VWrappedButtonAppearance = .init(),
        action: @escaping () -> Void,
        title: String,
        icon: Image
    )
        where CustomLabel == Never
    {
        self.appearance = appearance
        self.action = action
        self.label = .titleAndIcon(title: title, icon: icon)
    }
    
    /// Initializes `VWrappedButton` with action and custom label.
    public init(
        appearance: VWrappedButtonAppearance = .init(),
        action: @escaping () -> Void,
        @ViewBuilder label customLabel: @escaping (VWrappedButtonInternalState) -> CustomLabel
    ) {
        self.appearance = appearance
        self.action = action
        self.label = .custom(custom: customLabel)
    }
    
    // MARK: Body
    public var body: some View {
        SwiftUIBaseButton(
            appearance: appearance.baseButtonAppearance,
            action: {
                playHapticEffect()
                action()
            },
            label: { baseButtonState in
                let internalState: VWrappedButtonInternalState = internalState(baseButtonState)
                
                labelView(internalState: internalState)
                    .contentShape(.rect) // Registers gestures even when clear
                    .frame(height: appearance.height)
                    .background { backgroundView(internalState: internalState) }
                    .overlay { borderView(internalState: internalState) }
                    .clipShape(.rect(cornerRadius: appearance.cornerRadius))
                    .padding(appearance.hitBox)
            }
        )
    }
    
    private func labelView(
        internalState: VWrappedButtonInternalState
    ) -> some View {
        Group {
            switch label {
            case .title(let title):
                titleLabelViewComponent(internalState: internalState, title: title)

            case .icon(let icon):
                iconLabelViewComponent(internalState: internalState, icon: icon)

            case .titleAndIcon(let title, let icon):
                switch appearance.titleTextAndIconPlacement {
                case .titleAndIcon:
                    HStack(spacing: appearance.titleTextAndIconSpacing) {
                        titleLabelViewComponent(internalState: internalState, title: title)
                        iconLabelViewComponent(internalState: internalState, icon: icon)
                    }

                case .iconAndTitle:
                    HStack(spacing: appearance.titleTextAndIconSpacing) {
                        iconLabelViewComponent(internalState: internalState, icon: icon)
                        titleLabelViewComponent(internalState: internalState, title: title)
                    }
                }

            case .custom(let custom):
                custom(internalState)
            }
        }
        .scaleEffect(internalState == .pressed ? appearance.labelPressedScale : 1)
        .padding(appearance.labelMargins)
    }
    
    private func titleLabelViewComponent(
        internalState: VWrappedButtonInternalState,
        title: String
    ) -> some View {
        Text(title)
            .lineLimit(1)
            .minimumScaleFactor(appearance.titleTextMinimumScaleFactor)
            .foregroundStyle(appearance.titleTextColors.value(for: internalState))
            .font(appearance.titleTextFont)
            .applyIfLet(appearance.iconDynamicTypeSizeType) { $0.dynamicTypeSize(type: $1) }
    }
    
    private func iconLabelViewComponent(
        internalState: VWrappedButtonInternalState,
        icon: Image
    ) -> some View {
        icon
            .applyIf(appearance.isIconResizable) { $0.resizable() }
            .applyIfLet(appearance.iconContentMode) { $0.aspectRatio(nil, contentMode: $1) }
            .applyIfLet(appearance.iconColors) { $0.foregroundStyle($1.value(for: internalState)) }
            .applyIfLet(appearance.iconOpacities) { $0.opacity($1.value(for: internalState)) }
            .font(appearance.iconFont)
            .applyIfLet(appearance.iconDynamicTypeSizeType) { $0.dynamicTypeSize(type: $1) }
            .frame(size: appearance.iconSize)
    }
    
    private func backgroundView(
        internalState: VWrappedButtonInternalState
    ) -> some View {
        Rectangle()
            .scaleEffect(internalState == .pressed ? appearance.backgroundPressedScale : 1)
            .foregroundStyle(appearance.backgroundColors.value(for: internalState))
            .shadow(
                color: appearance.shadowColors.value(for: internalState),
                radius: appearance.shadowRadius,
                offset: appearance.shadowOffset
            )
    }
    
    @ViewBuilder
    private func borderView(
        internalState: VWrappedButtonInternalState
    ) -> some View {
        let borderWidth: CGFloat = appearance.borderWidth.toPoints(scale: displayScale)

        if borderWidth > 0 {
            RoundedRectangle(cornerRadius: appearance.cornerRadius)
                .strokeBorder(appearance.borderColors.value(for: internalState), lineWidth: borderWidth)
                .scaleEffect(internalState == .pressed ? appearance.backgroundPressedScale : 1)
        }
    }
    
    // MARK: Haptics
    private func playHapticEffect() {
#if os(iOS)
        HapticManager.shared.playImpact(appearance.haptic)
#elseif os(watchOS)
        HapticManager.shared.playImpact(appearance.haptic)
#endif
    }
}

// MARK: - Preview
#if DEBUG

#if !(os(tvOS) || os(visionOS)) // Redundant

#Preview("*") {
    PreviewContainer {
        VWrappedButton(
            action: {},
            title: "Lorem Ipsum"
        )
    }
}

#Preview("States") {
    PreviewContainer {
        PreviewRow("Enabled") {
            VWrappedButton(
                action: {},
                title: "Lorem Ipsum"
            )
        }

        PreviewRow("Pressed") {
            VWrappedButton(
                appearance: {
                    var appearance: VWrappedButtonAppearance = .init()
                    appearance.backgroundColors.enabled = appearance.backgroundColors.pressed
                    appearance.titleTextColors.enabled = appearance.titleTextColors.pressed
                    return appearance
                }(),
                action: {},
                title: "Lorem Ipsum"
            )
        }

        PreviewRow("Disabled") {
            VWrappedButton(
                action: {},
                title: "Lorem Ipsum"
            )
            .disabled(true)
        }
    }
}

#endif

#endif
