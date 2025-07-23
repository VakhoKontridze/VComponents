//
//  VRectangularButtonAppearance.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VCore

// MARK: - V Rectangular Button Appearance
/// Model that describes appearance.
@available(tvOS, unavailable)
@available(visionOS, unavailable)
public struct VRectangularButtonAppearance: Sendable {
    // MARK: Properties - Global
    var baseButtonAppearance: SwiftUIBaseButtonAppearance {
        var appearance: SwiftUIBaseButtonAppearance = .init()

        appearance.animatesStateChange = animatesStateChange

        return appearance
    }

    /// Size.
    public var size: CGSize = {
#if os(iOS)
        CGSize(dimension: 56)
#elseif os(macOS)
        CGSize(dimension: 28)
#elseif os(watchOS)
        CGSize(width: 64, height: 56)
#else
        fatalError() // Not supported
#endif
    }()

    // MARK: Properties - Corners
    /// Corner radius.
    public var cornerRadius: CGFloat = {
#if os(iOS)
        16
#elseif os(macOS)
        6
#elseif os(watchOS)
        16
#else
        fatalError() // Not supported
#endif
    }()

    // MARK: Properties - Background
    /// Background colors.
    public var backgroundColors: StateColors = .init(
        enabled: Color.platformDynamic(Color(24, 126, 240), Color(25, 131, 255)),
        pressed: Color.platformDynamic(Color(31, 104, 182), Color(36, 106, 186)),
        disabled: Color(128, 176, 240)
    )

    /// Background pressed scale.
    public var backgroundPressedScale: CGFloat = {
#if os(iOS)
        1
#elseif os(macOS)
        1
#elseif os(watchOS)
        0.98
#else
        fatalError() // Not supported
#endif
    }()

    // MARK: Properties - Border
    /// Border width.
    ///
    /// To hide border, set to `0`.
    public var borderWidth: PointPixelMeasurement = .points(0)

    /// Border colors.
    public var borderColors: StateColors = .clearColors

    // MARK: Properties - Label
    /// Label margins.
    public var labelMargins: EdgeInsets = .init(3)

    /// Label pressed scale.
    public var labelPressedScale: CGFloat = {
#if os(iOS)
        1
#elseif os(macOS)
        1
#elseif os(watchOS)
        0.98
#else
        fatalError() // Not supported
#endif
    }()

    // MARK: Properties - Label - Text
    /// Label text minimum scale factor.
    public var labelTextMinimumScaleFactor: CGFloat = 0.75

    /// Label text colors.
    public var labelTextColors: StateColors = .init(Color.white)

    /// Label text font.
    public var labelTextFont: Font = {
#if os(iOS)
        Font.subheadline.weight(.semibold)
#elseif os(macOS)
        Font.body
#elseif os(watchOS)
        Font.body.weight(.semibold)
#else
        fatalError() // Not supported
#endif
    }()

    /// Label text `DynamicTypeSize` type.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var labelTextDynamicTypeSizeType: DynamicTypeSizeType? = .partialRangeThrough(...(.accessibility2))

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
#elseif os(macOS)
        CGSize(dimension: 14)
#elseif os(watchOS)
        CGSize(dimension: 26)
#else
        fatalError() // Not supported
#endif
    }()

    /// Label image colors.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var labelImageColors: StateColors? = .init(Color.white)

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

    // MARK: Properties - Hit Box
    /// Hit box.
    public var hitBox: EdgeInsets = .init()

    // MARK: Properties - Transition - State Change
    /// Indicates if button animates state change.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var animatesStateChange: Bool = true

    // MARK: Properties - Shadow
    /// Shadow colors.
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
