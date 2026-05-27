//
//  VRectangularCaptionButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 17.08.22.
//

public import SwiftUI
public import VCore

/// Rectangular captioned button component that performs action when triggered.
///
///     var body: some View {
///         VRectangularCaptionButton(
///             action: { print("Clicked") },
///             labelImage: Image(systemName: "swift"),
///             captionTitle: "Lorem Ipsum"
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
    
    private func internalState(
        _ baseButtonState: SwiftUIBaseButtonState
    ) -> VRectangularCaptionButtonInternalState {
        .init(
            isEnabled: isEnabled,
            isPressed: baseButtonState == .pressed
        )
    }

    // MARK: Properties - Action
    private let action: () -> Void
    
    // MARK: Properties - Label & Caption
    private let labelImage: Image

    private let caption: VRectangularCaptionButtonCaption<CustomCaption>
    
    // MARK: Properties - Sensory Feedback
    @State private var sensoryFeedbackTrigger: SensoryFeedbackTrigger = .init()

    // MARK: Initializers
    /// Initializes `VRectangularCaptionButton` with action, label image, and caption title.
    public init(
        appearance: VRectangularCaptionButtonAppearance = .init(),
        action: @escaping () -> Void,
        labelImage: Image,
        captionTitle: String
    )
        where CustomCaption == Never
    {
        self.appearance = appearance
        self.action = action
        self.labelImage = labelImage
        self.caption = .title(title: captionTitle)
    }

    /// Initializes `VRectangularCaptionButton` with action, label image, and caption image.
    public init(
        appearance: VRectangularCaptionButtonAppearance = .init(),
        action: @escaping () -> Void,
        labelImage: Image,
        captionImage: Image
    )
        where CustomCaption == Never
    {
        self.appearance = appearance
        self.action = action
        self.labelImage = labelImage
        self.caption = .image(image: captionImage)
    }

    /// Initializes `VRectangularCaptionButton` with action, label image, caption image, and caption title.
    public init(
        appearance: VRectangularCaptionButtonAppearance = .init(),
        action: @escaping () -> Void,
        labelImage: Image,
        captionTitle: String,
        captionImage: Image
    )
        where CustomCaption == Never
    {
        self.appearance = appearance
        self.action = action
        self.labelImage = labelImage
        self.caption = .titleAndImage(title: captionTitle, image: captionImage)
    }
    
    /// Initializes `VRectangularCaptionButton` with action, label image, and custom caption.
    public init(
        appearance: VRectangularCaptionButtonAppearance = .init(),
        action: @escaping () -> Void,
        labelImage: Image,
        @ViewBuilder caption customCaption: @escaping (VRectangularCaptionButtonInternalState) -> CustomCaption
    ) {
        self.appearance = appearance
        self.action = action
        self.labelImage = labelImage
        self.caption = .custom(builder: customCaption)
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
                let internalState: VRectangularCaptionButtonInternalState = internalState(baseButtonState)
                
                VStack(spacing: appearance.rectangleAndCaptionSpacing) {
                    rectangleView(internalState: internalState)
                    captionView(internalState: internalState)
                }
                .contentShape(.rect) // Registers gestures even when clear
            }
        )
        .applyIfLet(appearance.sensoryFeedback) { $0.sensoryFeedback($1, trigger: sensoryFeedbackTrigger) }
    }
    
    private func rectangleView(
        internalState: VRectangularCaptionButtonInternalState
    ) -> some View {
        ZStack { // Used for additional frame
            labelImageView(
                internalState: internalState
            )
        }
        .frame(size: appearance.rectangleSize)
        .background { rectangleBackgroundView(internalState: internalState) }
        .overlay { rectangleBorderView(internalState: internalState) }
        .clipShape(.rect(cornerRadius: appearance.rectangleCornerRadius))
    }

    private func labelImageView(
        internalState: VPlainButtonInternalState
    ) -> some View {
        labelImage
            .imageConfiguration(appearance.labelImageConfiguration, state: internalState)
            .scaleEffect(internalState == .pressed ? appearance.labelImagePressedScale : 1)
            .padding(appearance.labelImageMargins)
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
                captionTextElement(internalState: internalState, title: title)

            case .image(let image):
                captionImageElement(internalState: internalState, image: image)

            case .titleAndImage(let title, let image):
                switch appearance.captionTextAndCaptionImagePlacement {
                case .textAndImage:
                    HStack(spacing: appearance.captionSpacing) {
                        captionTextElement(internalState: internalState, title: title)
                        captionImageElement(internalState: internalState, image: image)
                    }

                case .imageAndText:
                    HStack(spacing: appearance.captionSpacing) {
                        captionImageElement(internalState: internalState, image: image)
                        captionTextElement(internalState: internalState, title: title)
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
    
    private func captionTextElement(
        internalState: VRectangularCaptionButtonInternalState,
        title: String
    ) -> some View {
        Text(title)
            .textConfiguration(appearance.captionTextConfiguration, state: internalState)
    }
    
    private func captionImageElement(
        internalState: VRectangularCaptionButtonInternalState,
        image: Image
    ) -> some View {
        image
            .imageConfiguration(appearance.captionImageConfiguration, state: internalState)
    }
}

#if DEBUG

#if !(os(macOS) || os(tvOS) || os(visionOS)) // Redundant

#Preview("*") {
    PreviewContainer {
        VRectangularCaptionButton(
            action: {},
            labelImage: Image(systemName: "swift"),
            captionTitle: "Lorem Ipsum"
        )
    }
}

#Preview("States") {
    PreviewContainer {
        PreviewRow("Enabled") {
            VRectangularCaptionButton(
                action: {},
                labelImage: Image(systemName: "swift"),
                captionTitle: "Lorem Ipsum"
            )
        }

        PreviewRow("Pressed") {
            VRectangularCaptionButton(
                appearance: {
                    var appearance: VRectangularCaptionButtonAppearance = .init()
                    appearance.rectangleColors.enabled = appearance.rectangleColors.pressed
                    appearance.labelImageConfiguration.colors!.enabled = appearance.labelImageConfiguration.colors!.pressed // Unsafe (DEBUG)
                    appearance.captionTextConfiguration.colors!.enabled = appearance.captionTextConfiguration.colors!.pressed // Unsafe (DEBUG)
                    return appearance
                }(),
                action: {},
                labelImage: Image(systemName: "swift"),
                captionTitle: "Lorem Ipsum"
            )
        }

        PreviewRow("Disabled") {
            VRectangularCaptionButton(
                action: {},
                labelImage: Image(systemName: "swift"),
                captionTitle: "Lorem Ipsum"
            )
            .disabled(true)
        }
    }
}

#endif

#endif
