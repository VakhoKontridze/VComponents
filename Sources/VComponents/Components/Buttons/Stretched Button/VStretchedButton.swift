//
//  VStretchedButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 03.04.23.
//

import SwiftUI
import VCore

// MARK: - V Stretched Button
/// Stretched button component that performs action when triggered.
///
///     var body: some View {
///         VStretchedButton(
///             action: { print("Clicked") },
///             title: "Lorem Ipsum"
///         )
///         .padding(.horizontal)
///     }
///
/// On `macOS` and `watchOS`, an explicit width should be provided.
@available(tvOS, unavailable) // Doesn't follow HIG
@available(visionOS, unavailable)
public struct VStretchedButton<CustomLabel>: View where CustomLabel: View {
    // MARK: Properties - Appearance
    private let appearance: VStretchedButtonAppearance
    
    @Environment(\.displayScale) private var displayScale: CGFloat

    // MARK: Properties - State
    @Environment(\.isEnabled) private var isEnabled: Bool
    private func internalState(_ baseButtonState: SwiftUIBaseButtonState) -> VStretchedButtonInternalState {
        .init(
            isEnabled: isEnabled,
            isPressed: baseButtonState == .pressed
        )
    }

    // MARK: Properties - Action
    private let action: () -> Void

    // MARK: Properties - Label
    private let label: VStretchedButtonLabel<CustomLabel>

    // MARK: Initializers
    /// Initializes `VStretchedButton` with action and title.
    public init(
        appearance: VStretchedButtonAppearance = .init(),
        action: @escaping () -> Void,
        title: String
    )
        where CustomLabel == Never
    {
        self.appearance = appearance
        self.action = action
        self.label = .title(title: title)
    }

    /// Initializes `VStretchedButton` with action and image.
    public init(
        appearance: VStretchedButtonAppearance = .init(),
        action: @escaping () -> Void,
        image: Image
    )
        where CustomLabel == Never
    {
        self.appearance = appearance
        self.action = action
        self.label = .image(image: image)
    }

    /// Initializes `VStretchedButton` with action, title, and image.
    public init(
        appearance: VStretchedButtonAppearance = .init(),
        action: @escaping () -> Void,
        title: String,
        image: Image
    )
        where CustomLabel == Never
    {
        self.appearance = appearance
        self.action = action
        self.label = .titleAndImage(title: title, image: image)
    }
    
    /// Initializes `VStretchedButton` with action and custom label.
    public init(
        appearance: VStretchedButtonAppearance = .init(),
        action: @escaping () -> Void,
        @ViewBuilder label customLabel: @escaping (VStretchedButtonInternalState) -> CustomLabel
    ) {
        self.appearance = appearance
        self.action = action
        self.label = .custom(builder: customLabel)
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
                let internalState: VStretchedButtonInternalState = internalState(baseButtonState)
                
                labelView(internalState: internalState)
                    .contentShape(.rect) // Registers gestures even when clear
                    .frame(height: appearance.height)
                    .background { backgroundView(internalState: internalState) }
                    .overlay { borderView(internalState: internalState) }
                    .clipShape(.rect(cornerRadius: appearance.cornerRadius))
            }
        )
    }
    
    private func labelView(
        internalState: VStretchedButtonInternalState
    ) -> some View {
        Group {
            switch label {
            case .title(let title):
                labelTextElement(internalState: internalState, title: title)

            case .image(let image):
                labelImageElement(internalState: internalState, image: image)

            case .titleAndImage(let title, let image):
                switch appearance.labelTextAndLabelImagePlacement {
                case .textAndImage:
                    HStack(spacing: appearance.labelSpacing) {
                        labelTextElement(internalState: internalState, title: title)
                        labelImageElement(internalState: internalState, image: image)
                    }

                case .imageAndText:
                    HStack(spacing: appearance.labelSpacing) {
                        labelImageElement(internalState: internalState, image: image)
                        labelTextElement(internalState: internalState, title: title)
                    }
                }

            case .custom(let builder):
                builder(internalState)
            }
        }
        .frame(maxWidth: .infinity)
        .scaleEffect(internalState == .pressed ? appearance.labelPressedScale : 1)
        .padding(appearance.labelMargins)
    }
    
    private func labelTextElement(
        internalState: VStretchedButtonInternalState,
        title: String
    ) -> some View {
        Text(title)
            .lineLimit(1)
            .minimumScaleFactor(appearance.labelTextMinimumScaleFactor)
            .foregroundStyle(appearance.labelTextColors.value(for: internalState))
            .font(appearance.labelTextFont)
            .applyIfLet(appearance.labelTextDynamicTypeSizeType) { $0.dynamicTypeSize(type: $1) }
    }
    
    private func labelImageElement(
        internalState: VStretchedButtonInternalState,
        image: Image
    ) -> some View {
        image
            .applyIf(appearance.isLabelImageResizable) { $0.resizable() }
            .applyIfLet(appearance.labelImageContentMode) { $0.aspectRatio(nil, contentMode: $1) }
            .applyIfLet(appearance.labelImageColors) { $0.foregroundStyle($1.value(for: internalState)) }
            .applyIfLet(appearance.labelImageOpacities) { $0.opacity($1.value(for: internalState)) }
            .font(appearance.labelImageFont)
            .applyIfLet(appearance.labelImageDynamicTypeSizeType) { $0.dynamicTypeSize(type: $1) }
            .frame(size: appearance.labelImageSize)
    }
    
    private func backgroundView(
        internalState: VStretchedButtonInternalState
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
        internalState: VStretchedButtonInternalState
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
        VStretchedButton(
            action: {},
            title: "Lorem Ipsum"
        )
        .modifier(StretchedButtonFrameModifier())
    }
}

#Preview("States") {
    PreviewContainer {
        PreviewRow("Enabled") {
            VStretchedButton(
                action: {},
                title: "Lorem Ipsum"
            )
            .modifier(StretchedButtonFrameModifier())
        }

        PreviewRow("Pressed") {
            VStretchedButton(
                appearance: {
                    var appearance: VStretchedButtonAppearance = .init()
                    appearance.backgroundColors.enabled = appearance.backgroundColors.pressed
                    appearance.labelTextColors.enabled = appearance.labelTextColors.pressed
                    return appearance
                }(),
                action: {},
                title: "Lorem Ipsum"
            )
            .modifier(StretchedButtonFrameModifier())
        }

        PreviewRow("Disabled") {
            VStretchedButton(
                action: {},
                title: "Lorem Ipsum"
            )
            .modifier(StretchedButtonFrameModifier())
            .disabled(true)
        }
    }
}

#endif

#endif
