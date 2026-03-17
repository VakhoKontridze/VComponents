//
//  VRectangularButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VCore

/// Rectangular button component that performs action when triggered.
///
///     var body: some View {
///         VRectangularButton(
///             action: { print("Clicked") },
///             image: Image(systemName: "swift")
///         )
///     }
///
@available(tvOS, unavailable) // Doesn't follow HIG
@available(visionOS, unavailable) // Doesn't follow HIG
public struct VRectangularButton<CustomLabel>: View where CustomLabel: View {
    // MARK: Properties - Appearance
    private let appearance: VRectangularButtonAppearance
    
    @Environment(\.displayScale) private var displayScale: CGFloat

    // MARK: Properties - State
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    private func internalState(
        _ baseButtonState: SwiftUIBaseButtonState
    ) -> VRectangularButtonInternalState {
        .init(
            isEnabled: isEnabled,
            isPressed: baseButtonState == .pressed
        )
    }

    // MARK: Properties - Action
    private let action: () -> Void

    // MARK: Properties - Label
    private let label: VRectangularButtonLabel<CustomLabel>
    
    // MARK: Properties - Sensory Feedback
    @State private var sensoryFeedbackTrigger: SensoryFeedbackTrigger = .init()

    // MARK: Initializers
    /// Initializes `VRectangularButton` with action and title.
    public init(
        appearance: VRectangularButtonAppearance = .init(),
        action: @escaping () -> Void,
        title: String
    )
        where CustomLabel == Never
    {
        self.appearance = appearance
        self.action = action
        self.label = .title(title: title)
    }
    
    /// Initializes `VRectangularButton` with action and image.
    public init(
        appearance: VRectangularButtonAppearance = .init(),
        action: @escaping () -> Void,
        image: Image
    )
        where CustomLabel == Never
    {
        self.appearance = appearance
        self.action = action
        self.label = .image(image: image)
    }
    
    /// Initializes `VRectangularButton` with action and custom label.
    public init(
        appearance: VRectangularButtonAppearance = .init(),
        action: @escaping () -> Void,
        @ViewBuilder label customLabel: @escaping (VRectangularButtonInternalState) -> CustomLabel
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
                let internalState: VRectangularButtonInternalState = internalState(baseButtonState)
                
                labelView(internalState: internalState)
                    .contentShape(.rect) // Registers gestures even when clear
                    .frame(size: appearance.size)
                    .background { backgroundView(internalState: internalState) }
                    .overlay { borderView(internalState: internalState) }
                    .clipShape(.rect(cornerRadius: appearance.cornerRadius))
            }
        )
        .applyIfLet(appearance.sensoryFeedback) { $0.sensoryFeedback($1, trigger: sensoryFeedbackTrigger) }
    }
    
    private func labelView(
        internalState: VRectangularButtonInternalState
    ) -> some View {
        Group {
            switch label {
            case .title(let title):
                labelTextElement(internalState: internalState, title: title)
                
            case .image(let image):
                labelImageElement(internalState: internalState, image: image)
                
            case .custom(let builder):
                builder(internalState)
            }
        }
        .scaleEffect(internalState == .pressed ? appearance.labelPressedScale : 1)
        .padding(appearance.labelMargins)
    }
    
    private func labelTextElement(
        internalState: VRectangularButtonInternalState,
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
        internalState: VRectangularButtonInternalState,
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
    
    private func backgroundView(
        internalState: VRectangularButtonInternalState
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
        internalState: VRectangularButtonInternalState
    ) -> some View {
        let borderWidth: CGFloat = appearance.borderWidth.toPoints(scale: displayScale)

        if borderWidth > 0 {
            RoundedRectangle(cornerRadius: appearance.cornerRadius)
                .strokeBorder(appearance.borderColors.value(for: internalState), lineWidth: borderWidth)
                .scaleEffect(internalState == .pressed ? appearance.backgroundPressedScale : 1)
        }
    }
}

#if DEBUG

#if !(os(tvOS) || os(visionOS)) // Redundant

#Preview("*") {
    PreviewContainer {
        VRectangularButton(
            action: {},
            title: "ABC"
        )

        VRectangularButton(
            action: {},
            image: Image(systemName: "swift")
        )
    }
}

#Preview("States") {
    PreviewContainer {
        PreviewRow("Enabled") {
            VRectangularButton(
                action: {},
                image: Image(systemName: "swift")
            )
        }

        PreviewRow("Pressed") {
            VRectangularButton(
                appearance: {
                    var appearance: VRectangularButtonAppearance = .init()
                    appearance.backgroundColors.enabled = appearance.backgroundColors.pressed
                    appearance.labelImageColors!.enabled = appearance.labelImageColors!.pressed // Unsafe (DEBUG)
                    return appearance
                }(),
                action: {},
                image: Image(systemName: "swift")
            )
        }

    PreviewRow("Disabled") {
            VRectangularButton(
                action: {},
                image: Image(systemName: "swift")
            )
            .disabled(true)
        }
    }
}

#endif

#endif
