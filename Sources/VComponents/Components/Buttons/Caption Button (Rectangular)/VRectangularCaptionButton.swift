//
//  VRectangularCaptionButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 17.08.22.
//

import SwiftUI
import VCore

// MARK: - V Rectangular Caption Button
/// Rectangular captioned button component that performs action when triggered.
///
///     var body: some View {
///         VRectangularCaptionButton(
///             action: { print("Clicked") },
///             icon: Image(systemName: "swift"),
///             titleCaption: "Lorem Ipsum"
///         )
///     }
///
@available(macOS, unavailable) // Doesn't follow HIG
@available(tvOS, unavailable) // Doesn't follow HIG
@available(visionOS, unavailable) // Doesn't follow HIG
public struct VRectangularCaptionButton<CustomCaption>: View where CustomCaption: View {
    // MARK: Properties - Appearance
    private let appearance: VRectangularCaptionButtonAppearance
    
    @Environment(\.displayScale) private var displayScale: CGFloat

    // MARK: Properties - State
    @Environment(\.isEnabled) private var isEnabled: Bool
    private func internalState(_ baseButtonState: SwiftUIBaseButtonState) -> VRectangularCaptionButtonInternalState {
        .init(
            isEnabled: isEnabled,
            isPressed: baseButtonState == .pressed
        )
    }

    // MARK: Properties - Action
    private let action: () -> Void
    
    // MARK: Properties - Label & Caption
    private let icon: Image

    private let caption: VRectangularCaptionButtonCaption<CustomCaption>

    // MARK: Initializers
    /// Initializes `VRectangularCaptionButton` with action, icon, and title caption.
    public init(
        appearance: VRectangularCaptionButtonAppearance = .init(),
        action: @escaping () -> Void,
        icon: Image,
        titleCaption: String
    )
        where CustomCaption == Never
    {
        self.appearance = appearance
        self.action = action
        self.icon = icon
        self.caption = .title(title: titleCaption)
    }

    /// Initializes `VRectangularCaptionButton` with action, icon, and icon caption.
    public init(
        appearance: VRectangularCaptionButtonAppearance = .init(),
        action: @escaping () -> Void,
        icon: Image,
        iconCaption: Image
    )
        where CustomCaption == Never
    {
        self.appearance = appearance
        self.action = action
        self.icon = icon
        self.caption = .icon(icon: iconCaption)
    }

    /// Initializes `VRectangularCaptionButton` with action, icon, icon caption, and title caption.
    public init(
        appearance: VRectangularCaptionButtonAppearance = .init(),
        action: @escaping () -> Void,
        icon: Image,
        titleCaption: String,
        iconCaption: Image
    )
        where CustomCaption == Never
    {
        self.appearance = appearance
        self.action = action
        self.icon = icon
        self.caption = .titleAndIcon(title: titleCaption, icon: iconCaption)
    }
    
    /// Initializes `VRectangularCaptionButton` with action, icon, and custom caption.
    public init(
        appearance: VRectangularCaptionButtonAppearance = .init(),
        action: @escaping () -> Void,
        icon: Image,
        @ViewBuilder caption customCaption: @escaping (VRectangularCaptionButtonInternalState) -> CustomCaption
    ) {
        self.appearance = appearance
        self.action = action
        self.icon = icon
        self.caption = .custom(builder: customCaption)
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
                let internalState: VRectangularCaptionButtonInternalState = internalState(baseButtonState)
                
                VStack(spacing: appearance.rectangleAndCaptionSpacing) {
                    rectangleView(internalState: internalState)
                    captionView(internalState: internalState)
                }
                .contentShape(.rect) // Registers gestures even when clear
            }
        )
    }
    
    private func rectangleView(
        internalState: VRectangularCaptionButtonInternalState
    ) -> some View {
        Group { // `Group` is used for adding multiple frames
            rectangleIcon(
                internalState: internalState
            )
        }
        .frame(size: appearance.rectangleSize)
        .background { rectangleBackgroundView(internalState: internalState) }
        .overlay { rectangleBorderView(internalState: internalState) }
        .clipShape(.rect(cornerRadius: appearance.rectangleCornerRadius))
    }

    private func rectangleIcon(
        internalState: VPlainButtonInternalState
    ) -> some View {
        icon
            .applyIf(appearance.isIconResizable) { $0.resizable() }
            .applyIfLet(appearance.iconContentMode) { $0.aspectRatio(nil, contentMode: $1) }
            .applyIfLet(appearance.iconColors) { $0.foregroundStyle($1.value(for: internalState)) }
            .applyIfLet(appearance.iconOpacities) { $0.opacity($1.value(for: internalState)) }
            .font(appearance.iconFont)
            .applyIfLet(appearance.iconDynamicTypeSizeType) { $0.dynamicTypeSize(type: $1) }
            .frame(size: appearance.iconSize)
            .scaleEffect(internalState == .pressed ? appearance.iconPressedScale : 1)
            .padding(appearance.iconMargins)
    }

    private func rectangleBackgroundView(
        internalState: VRectangularCaptionButtonInternalState
    ) -> some View {
        Rectangle()
            .scaleEffect(internalState == .pressed ? appearance.rectanglePressedScale : 1)
            .foregroundStyle(appearance.rectangleColors.value(for: internalState))
            .shadow(
                color: appearance.shadowColors.value(for: internalState),
                radius: appearance.shadowRadius,
                offset: appearance.shadowOffset
            )
    }
    
    @ViewBuilder 
    private func rectangleBorderView(
        internalState: VRectangularCaptionButtonInternalState
    ) -> some View {
        let borderWidth: CGFloat = appearance.rectangleBorderWidth.toPoints(scale: displayScale)

        if borderWidth > 0 {
            RoundedRectangle(cornerRadius: appearance.rectangleCornerRadius)
                .strokeBorder(appearance.rectangleBorderColors.value(for: internalState), lineWidth: borderWidth)
                .scaleEffect(internalState == .pressed ? appearance.rectanglePressedScale : 1)
        }
    }
    
    private func captionView(
        internalState: VRectangularCaptionButtonInternalState
    ) -> some View {
        Group {
            switch caption {
            case .title(let title):
                titleCaptionViewComponent(internalState: internalState, title: title)

            case .icon(let icon):
                iconCaptionViewComponent(internalState: internalState, icon: icon)

            case .titleAndIcon(let title, let icon):
                switch appearance.titleCaptionTextAndIconCaptionPlacement {
                case .titleAndIcon:
                    HStack(spacing: appearance.titleCaptionTextAndIconCaptionSpacing) {
                        titleCaptionViewComponent(internalState: internalState, title: title)
                        iconCaptionViewComponent(internalState: internalState, icon: icon)
                    }

                case .iconAndTitle:
                    HStack(spacing: appearance.titleCaptionTextAndIconCaptionSpacing) {
                        iconCaptionViewComponent(internalState: internalState, icon: icon)
                        titleCaptionViewComponent(internalState: internalState, title: title)
                    }
                }

            case .custom(let builder):
                builder(internalState)
            }
        }
        .frame(
            maxWidth: appearance.captionWidthMax,
            alignment: Alignment(
                horizontal: appearance.captionFrameAlignment,
                vertical: .center
            )
        )
        .scaleEffect(internalState == .pressed ? appearance.captionPressedScale : 1)
    }
    
    private func titleCaptionViewComponent(
        internalState: VRectangularCaptionButtonInternalState,
        title: String
    ) -> some View {
        Text(title)
            .multilineTextAlignment(appearance.titleCaptionTextLineType.textAlignment ?? .leading)
            .lineLimit(type: appearance.titleCaptionTextLineType.textLineLimitType)
            .minimumScaleFactor(appearance.titleCaptionTextMinimumScaleFactor)
            .foregroundStyle(appearance.titleCaptionTextColors.value(for: internalState))
            .font(appearance.titleCaptionTextFont)
            .applyIfLet(appearance.titleCaptionTextDynamicTypeSizeType) { $0.dynamicTypeSize(type: $1) }
    }
    
    private func iconCaptionViewComponent(
        internalState: VRectangularCaptionButtonInternalState,
        icon: Image
    ) -> some View {
        icon
            .applyIf(appearance.isIconCaptionResizable) { $0.resizable() }
            .applyIfLet(appearance.iconCaptionContentMode) { $0.aspectRatio(nil, contentMode: $1) }
            .applyIfLet(appearance.iconCaptionColors) { $0.foregroundStyle($1.value(for: internalState)) }
            .applyIfLet(appearance.iconCaptionOpacities) { $0.opacity($1.value(for: internalState)) }
            .font(appearance.iconCaptionFont)
            .applyIfLet(appearance.iconCaptionDynamicTypeSizeType) { $0.dynamicTypeSize(type: $1) }
            .frame(size: appearance.iconCaptionSize)
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

#if !(os(macOS) || os(tvOS) || os(visionOS)) // Redundant

#Preview("*") {
    PreviewContainer {
        VRectangularCaptionButton(
            action: {},
            icon: Image(systemName: "swift"),
            titleCaption: "Lorem Ipsum"
        )
    }
}

#Preview("States") {
    PreviewContainer {
        PreviewRow("Enabled") {
            VRectangularCaptionButton(
                action: {},
                icon: Image(systemName: "swift"),
                titleCaption: "Lorem Ipsum"
            )
        }

        PreviewRow("Pressed") {
            VRectangularCaptionButton(
                appearance: {
                    var appearance: VRectangularCaptionButtonAppearance = .init()
                    appearance.rectangleColors.enabled = appearance.rectangleColors.pressed
                    appearance.iconColors!.enabled = appearance.iconColors!.pressed // Force-unwrap
                    appearance.titleCaptionTextColors.enabled = appearance.titleCaptionTextColors.pressed
                    return appearance
                }(),
                action: {},
                icon: Image(systemName: "swift"),
                titleCaption: "Lorem Ipsum"
            )
        }

        PreviewRow("Disabled") {
            VRectangularCaptionButton(
                action: {},
                icon: Image(systemName: "swift"),
                titleCaption: "Lorem Ipsum"
            )
            .disabled(true)
        }
    }
}

#endif

#endif
