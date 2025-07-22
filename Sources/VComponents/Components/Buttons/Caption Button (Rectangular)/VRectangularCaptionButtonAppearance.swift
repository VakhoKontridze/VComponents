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

    // MARK: Properties - Icon
    /// Indicates if `resizable(...)` modifier is applied to icon.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var isIconResizable: Bool = true

    /// Icon content mode.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var iconContentMode: ContentMode? = .fit

    /// Icon size.
    public var iconSize: CGSize? = {
#if os(iOS)
        CGSize(dimension: 24)
#elseif os(watchOS)
        CGSize(dimension: 26)
#else
        fatalError() // Not supported
#endif
    }()

    /// Icon colors.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var iconColors: StateColors? = .init(
        enabled: Color.platformDynamic(Color(24, 126, 240), Color(25, 131, 255)),
        pressed: Color.platformDynamic(Color(31, 104, 182), Color(36, 106, 186)),
        disabled: Color(128, 176, 240, 0.5)
    )

    /// Icon opacities.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var iconOpacities: StateOpacities?

    /// Icon font.`
    ///
    /// Can be used for setting different weight to SF symbol icons.
    /// To achieve this, `isIconResizable` should be set to `false`, and `iconSize` should be set to `nil`.
    public var iconFont: Font?

    /// Icon `DynamicTypeSize` type.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var iconDynamicTypeSizeType: DynamicTypeSizeType?

    /// Icon pressed scale.
    public var iconPressedScale: CGFloat = {
#if os(iOS)
        1
#elseif os(watchOS)
        0.98
#else
        fatalError() // Not supported
#endif
    }()

    /// Icon margins.
    public var iconMargins: EdgeInsets = .init(3)

    // MARK: Properties - Caption
    /// Maximum caption width.
    public var captionWidthMax: CGFloat = 100

    /// Caption text frame alignment.
    public var captionFrameAlignment: HorizontalAlignment = .center

    /// Title caption text and icon caption placement.
    public var titleCaptionTextAndIconCaptionPlacement: TitleAndIconPlacement = .iconAndTitle

    /// Spacing between title caption text and icon caption.
    ///
    /// Applicable only if `init` with icon and title is used.
    public var titleCaptionTextAndIconCaptionSpacing: CGFloat = 8

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

    // MARK: Properties - Caption - Icon
    /// Indicates if `resizable(...)` modifier is applied to icon caption.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var isIconCaptionResizable: Bool = true

    /// Icon caption content mode.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var iconCaptionContentMode: ContentMode? = .fit

    /// Icon caption size.
    public var iconCaptionSize: CGSize? = {
#if os(iOS)
        CGSize(dimension: 16)
#elseif os(watchOS)
        CGSize(dimension: 18)
#else
        fatalError() // Not supported
#endif
    }()

    /// Icon caption colors.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var iconCaptionColors: StateColors? = .init(
        enabled: Color.primary,
        pressed: Color.primary.opacity(0.3),
        disabled: Color.primary.opacity(0.3)
    )

    /// Icon caption opacities.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var iconCaptionOpacities: StateOpacities?

    /// Icon caption font.`
    ///
    /// Can be used for setting different weight to SF symbol icons.
    /// To achieve this, `isIconCaptionResizable` should be set to `false`, and `iconCaptionSize` should be set to `nil`.
    public var iconCaptionFont: Font?

    /// Icon caption `DynamicTypeSize` type.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var iconCaptionDynamicTypeSizeType: DynamicTypeSizeType?

    // MARK: Properties - Caption - Text
    /// Title caption text line type.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var titleCaptionTextLineType: TextLineType = {
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
    
    /// Title caption text minimum scale factor.
    public var titleCaptionTextMinimumScaleFactor: CGFloat = 0.75

    /// Title caption text colors.
    public var titleCaptionTextColors: StateColors = .init(
        enabled: Color.primary,
        pressed: Color.primary.opacity(0.3),
        disabled: Color.primary.opacity(0.3)
    )

    /// Title caption text font.
    public var titleCaptionTextFont: Font = {
#if os(iOS)
        Font.subheadline
#elseif os(watchOS)
        Font.body
#else
        fatalError() // Not supported
#endif
    }()

    /// Title caption text `DynamicTypeSize` type.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var titleCaptionTextDynamicTypeSizeType: DynamicTypeSizeType?

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
