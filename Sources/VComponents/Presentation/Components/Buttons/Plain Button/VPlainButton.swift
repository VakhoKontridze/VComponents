//
//  VPlainButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VCore

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
    
    private func internalState(
        _ baseButtonState: SwiftUIBaseButtonState
    ) -> VPlainButtonInternalState {
        .init(
            isEnabled: isEnabled,
            isPressed: baseButtonState == .pressed
        )
    }

    // MARK: Properties - Action
    private let action: () -> Void

    // MARK: Properties - Label
    private let label: VPlainButtonLabel<CustomLabel>
    
    // MARK: Properties - Sensory Feedback
    @State private var sensoryFeedbackTrigger: SensoryFeedbackTrigger = .init()

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
    
    /// Initializes `VPlainButton` with action and image.
    public init(
        appearance: VPlainButtonAppearance = .init(),
        action: @escaping () -> Void,
        image: Image
    )
        where CustomLabel == Never
    {
        self.appearance = appearance
        self.action = action
        self.label = .image(image: image)
    }
    
    /// Initializes `VPlainButton` with action, title, and image.
    public init(
        appearance: VPlainButtonAppearance = .init(),
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
    
    /// Initializes `VPlainButton` with action and custom label.
    public init(
        appearance: VPlainButtonAppearance = .init(),
        action: @escaping () -> Void,
        @ViewBuilder label customLabel: @escaping (VPlainButtonInternalState) -> CustomLabel
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
                action()
                sensoryFeedbackTrigger()
            },
            label: { baseButtonState in
                let internalState: VPlainButtonInternalState = internalState(baseButtonState)
                
                labelView(internalState: internalState)
                    .contentShape(.rect) // Registers gestures even when clear
            }
        )
        .applyIfLet(appearance.sensoryFeedback) { $0.sensoryFeedback($1, trigger: sensoryFeedbackTrigger) }
    }
    
    private func labelView(
        internalState: VPlainButtonInternalState
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
        .scaleEffect(internalState == .pressed ? appearance.labelPressedScale : 1)
    }
    
    private func labelTextElement(
        internalState: VPlainButtonInternalState,
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
        internalState: VPlainButtonInternalState,
        image: Image
    ) -> some View {
        image
            .applyIf(appearance.isLabelImageResizable) { $0.resizable() }
            .applyIfLet(appearance.labelImageContentMode) { $0.aspectRatio(nil, contentMode: $1) }
            .frame(size: appearance.labelImageSize)
            .applyIfLet(appearance.labelImageColors) { $0.foregroundStyle($1.value(for: internalState)) }
            .applyIfLet(appearance.labelImageOpacities) { $0.opacity($1.value(for: internalState)) }
            .font(appearance.labelImageFont)
            .applyIfLet(appearance.labelImageDynamicTypeSizeType) { $0.dynamicTypeSize(type: $1) }
    }
}

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
            image: Image(systemName: "swift")
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
                    appearance.labelTextColors.enabled = appearance.labelTextColors.pressed
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
