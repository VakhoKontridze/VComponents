//
//  VRectangularCaptionButtonAppearance.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 17.08.22.
//

import SwiftUI
import VCore

// MARK: - V Rectangular Caption Button Appearance
/// Model that describes appearance.
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(visionOS, unavailable)
public struct VRectangularCaptionButtonAppearance: Sendable {
    // MARK: Properties - Global
    var baseButtonAppearance: SwiftUIBaseButtonAppearance {
        var appearance: SwiftUIBaseButtonAppearance = .init()

        appearance.animatesStateChange = animatesStateChange

        return appearance
    }

    /// Spacing between rectangle and caption.
    public var rectangleAndCaptionSpacing: CGFloat = {
#if os(iOS)
        7
#elseif os(watchOS)
        3
#else
        fatalError() // Not supported
#endif
    }()

    // MARK: Properties - Rectangle
    /// Rectangle size.
    public var rectangleSize: CGSize = {
#if os(iOS)
        CGSize(dimension: 56)
#elseif os(watchOS)
        CGSize(width: 64, height: 56)
#else
        fatalError() // Not supported
#endif
    }()

    /// Rectangle corner radius.
    public var rectangleCornerRadius: CGFloat = 24

    /// Rectangle colors.
    public var rectangleColors: StateColors = .init(
        enabled: Color.platformDynamic(Color(24, 126, 240, 0.25), Color(25, 131, 255, 0.35)),
        pressed: Color.platformDynamic(Color(31, 104, 182, 0.25), Color(36, 106, 186, 0.35)),
        disabled: Color(128, 176, 240, 0.35)
    )

    /// Rectangle pressed scale.
    public var rectanglePressedScale: CGFloat = {
#if os(iOS)
        1
#elseif os(watchOS)
        0.98
#else
        fatalError() // Not supported
#endif
    }()

    /// Rectangle border width.
    ///
    /// To hide border, set to `0`.
    public var rectangleBorderWidth: PointPixelMeasurement = .points(0)

    /// Rectangle border colors.
    public var rectangleBorderColors: StateColors = .clearColors

    // MARK: Properties - Label - Image
    /// Indicates if label image is resizable.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var isLabelImageResizable: Bool = true

    /// Label image content mode.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var labelImageContentMode: ContentMode? = .fit

    /// Label image size.
    public var labelImageSize: CGSize? = {
#if os(iOS)
        CGSize(dimension: 24)
#elseif os(watchOS)
        CGSize(dimension: 26)
#else
        fatalError() // Not supported
#endif
    }()

    /// Label image colors.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var labelImageColors: StateColors? = .init(
        enabled: Color.platformDynamic(Color(24, 126, 240), Color(25, 131, 255)),
        pressed: Color.platformDynamic(Color(31, 104, 182), Color(36, 106, 186)),
        disabled: Color(128, 176, 240, 0.5)
    )

    /// Label image opacities.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var labelImageOpacities: StateOpacities?

    /// Label image font.
    ///
    /// Can be used for setting different weight to SF symbol images.
    /// To achieve this, `isLabelImageResizable` should be set to `false`, and `labelImageSize` should be set to `nil`.
    public var labelImageFont: Font?

    /// Label image `DynamicTypeSize` type.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var labelImageDynamicTypeSizeType: DynamicTypeSizeType?

    /// Label image pressed scale.
    public var labelImagePressedScale: CGFloat = {
#if os(iOS)
        1
#elseif os(watchOS)
        0.98
#else
        fatalError() // Not supported
#endif
    }()

    /// Label image margins.
    public var labelImageMargins: EdgeInsets = .init(3)

    // MARK: Properties - Caption
    /// Maximum caption width.
    public var captionWidthMax: CGFloat = 100

    /// Caption frame alignment.
    public var captionFrameAlignment: HorizontalAlignment = .center

    /// Caption text and caption image placement.
    public var captionTextAndCaptionImagePlacement: TextAndImagePlacement = .imageAndText

    /// Caption spacing.
    ///
    /// Applicable only if `init` with image and title is used.
    public var captionSpacing: CGFloat = 8

    /// Caption pressed scale.
    public var captionPressedScale: CGFloat = {
#if os(iOS)
        1
#elseif os(watchOS)
        0.98
#else
        fatalError() // Not supported
#endif
    }()
    
    // MARK: Properties - Caption - Text
    /// Caption text line type.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var captionTextLineType: TextLineType = {
#if os(iOS)
        .multiLine(
            alignment: .center,
            lineLimit: 1...2
        )
#elseif os(watchOS)
        .singleLine
#else
        fatalError() // Not supported
#endif
    }()
    
    /// Caption text minimum scale factor.
    public var captionTextMinimumScaleFactor: CGFloat = 0.75

    /// Caption text colors.
    public var captionTextColors: StateColors = .init(
        enabled: Color.primary,
        pressed: Color.primary.opacity(0.3),
        disabled: Color.primary.opacity(0.3)
    )

    /// Caption text font.
    public var captionTextFont: Font = {
#if os(iOS)
        Font.subheadline
#elseif os(watchOS)
        Font.body
#else
        fatalError() // Not supported
#endif
    }()

    /// Caption text `DynamicTypeSize` type.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var captionTextDynamicTypeSizeType: DynamicTypeSizeType?

    // MARK: Properties - Caption - Image
    /// Indicates if caption image is resizable.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var isCaptionImageResizable: Bool = true

    /// Caption image content mode.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var captionImageContentMode: ContentMode? = .fit

    /// Caption image size.
    public var captionImageSize: CGSize? = {
#if os(iOS)
        CGSize(dimension: 16)
#elseif os(watchOS)
        CGSize(dimension: 18)
#else
        fatalError() // Not supported
#endif
    }()

    /// Caption image colors.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var captionImageColors: StateColors? = .init(
        enabled: Color.primary,
        pressed: Color.primary.opacity(0.3),
        disabled: Color.primary.opacity(0.3)
    )

    /// Caption image opacities.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var captionImageOpacities: StateOpacities?

    /// Caption image font.
    ///
    /// Can be used for setting different weight to SF symbol images.
    /// To achieve this, `isCaptionImageResizable` should be set to `false`, and `captionImageSize` should be set to `nil`.
    public var captionImageFont: Font?

    /// Caption image `DynamicTypeSize` type.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var captionImageDynamicTypeSizeType: DynamicTypeSizeType?

    // MARK: Properties - Transition - State Change
    /// Indicates if button animates state change.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var animatesStateChange: Bool = true

    // MARK: Properties - Shadow
    /// Shadow colors.
    ///
    /// By default, `background` of button is transparent.
    /// And applying shadow directly without making it opaque is not recommended.
    public var shadowColors: StateColors = .clearColors

    /// Shadow radius.
    public var shadowRadius: CGFloat = 0

    /// Shadow offset.
    public var shadowOffset: CGPoint = .zero

    // MARK: Properties - Haptic
#if os(iOS)
    /// Haptic feedback style.
    public var haptic: UIImpactFeedbackGenerator.FeedbackStyle?
#elseif os(watchOS)
    /// Haptic feedback type.
    public var haptic: WKHapticType?
#endif
    
    // MARK: Initializers
    /// Initializes appearance with default values.
    public init() {}

    // MARK: State Colors
    /// Model that contains colors for component states.
    public typealias StateColors = GenericStateModel_EnabledPressedDisabled<Color>

    // MARK: State Opacities
    /// Model that contains opacities for component states.
    public typealias StateOpacities = GenericStateModel_EnabledPressedDisabled<CGFloat>
}
