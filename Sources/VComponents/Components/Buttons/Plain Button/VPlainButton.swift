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
///     var body: some View {
///         VPlain(
///             action: { print("Clicked") },
///             title: "Lorem Ipsum"
///         )
///     }
///
@available(tvOS, unavailable) // Doesn't follow HIG
@available(visionOS, unavailable) // Doesn't follow HIG
public struct VPlainButton<CustomLabel>: View where CustomLabel: View {
    // MARK: Properties - Appearance
    private let appearance: VPlainButtonAppearance

    // MARK: Properties - State
    @Environment(\.isEnabled) private var isEnabled: Bool
    private func internalState(_ baseButtonState: SwiftUIBaseButtonState) -> VPlainButtonInternalState {
        .init(
            isEnabled: isEnabled,
            isPressed: baseButtonState == .pressed
        )
    }

    // MARK: Properties - Action
    private let action: () -> Void

    // MARK: Properties - Label
    private let label: VPlainButtonLabel<CustomLabel>

    // MARK: Initializers
    /// Initializes `VPlainButton` with action and title.
    public init(
        appearance: VPlainButtonAppearance = .init(),
        action: @escaping () -> Void,
        title: String
    )
        where CustomLabel == Never
    {
        self.appearance = appearance
        self.action = action
        self.label = .title(title: title)
    }
    
    /// Initializes `VPlainButton` with action and icon.
    public init(
        appearance: VPlainButtonAppearance = .init(),
        action: @escaping () -> Void,
        icon: Image
    )
        where CustomLabel == Never
    {
        self.appearance = appearance
        self.action = action
        self.label = .icon(icon: icon)
    }
    
    /// Initializes `VPlainButton` with action, icon, and title.
    public init(
        appearance: VPlainButtonAppearance = .init(),
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
    
    /// Initializes `VPlainButton` with action and custom label.
    public init(
        appearance: VPlainButtonAppearance = .init(),
        action: @escaping () -> Void,
        @ViewBuilder label customLabel: @escaping (VPlainButtonInternalState) -> CustomLabel
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
                let internalState: VPlainButtonInternalState = internalState(baseButtonState)
                
                labelView(internalState: internalState)
                    .contentShape(.rect) // Registers gestures even when clear
            }
        )
    }
    
    private func labelView(
        internalState: VPlainButtonInternalState
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
        .padding(appearance.hitBox)
    }
    
    private func titleLabelViewComponent(
        internalState: VPlainButtonInternalState,
        title: String
    ) -> some View {
        Text(title)
            .lineLimit(1)
            .minimumScaleFactor(appearance.titleTextMinimumScaleFactor)
            .foregroundStyle(appearance.titleTextColors.value(for: internalState))
            .font(appearance.titleTextFont)
            .applyIfLet(appearance.titleTextDynamicTypeSizeType) { $0.dynamicTypeSize(type: $1) }
    }
    
    private func iconLabelViewComponent(
        internalState: VPlainButtonInternalState,
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
        VPlainButton(
            action: {},
            title: "Lorem Ipsum"
        )

        VPlainButton(
            action: {},
            icon: Image(systemName: "swift")
        )
    }
}

#Preview("States") {
    PreviewContainer {
        PreviewRow("Enabled") {
            VPlainButton(
                action: {},
                title: "Lorem Ipsum"
            )
        }

        PreviewRow("Pressed") {
            VPlainButton(
                appearance: {
                    var appearance: VPlainButtonAppearance = .init()
                    appearance.titleTextColors.enabled = appearance.titleTextColors.pressed
                    return appearance
                }(),
                action: {},
                title: "Lorem Ipsum"
            )
        }

        PreviewRow("Disabled") {
            VPlainButton(
                action: {},
                title: "Lorem Ipsum"
            )
            .disabled(true)
        }

        PreviewHeader("Native")

        PreviewRow("Enabled") {
            Button("Lorem Ipsum") {}
                .buttonStyle(.plain)
                .foregroundStyle(Color.blue)
        }

        PreviewRow("Disabled") {
            Button("Lorem Ipsum") {}
                .buttonStyle(.plain)
                .foregroundStyle(Color.blue)
                .disabled(true)
        }
    }
}

#endif

#endif
