//
//  VPlainButtonAppearance.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VCore

// MARK: - V Plain Button Appearance
/// Model that describes appearance.
@available(tvOS, unavailable)
@available(visionOS, unavailable)
public struct VPlainButtonAppearance: Sendable {
    // MARK: Properties - Global
    var baseButtonAppearance: SwiftUIBaseButtonAppearance {
        var appearance: SwiftUIBaseButtonAppearance = .init()

        appearance.animatesStateChange = animatesStateChange

        return appearance
    }

    // MARK: Properties - Label
    /// Label text and label image placement.
    public var labelTextAndLabelImagePlacement: TextAndImagePlacement = .imageAndText

    /// Label spacing.
    ///
    /// Applicable only if `init` with title and image is used.
    public var labelSpacing: CGFloat = 8

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
    public var labelTextColors: StateColors = .init(
        enabled: Color.blue,
        pressed: Color.platformDynamic(Color.blue.opacity(0.3), Color.blue.opacity(0.5)),
        disabled: Color.platformDynamic(Color.blue.opacity(0.3), Color.blue.opacity(0.5))
    )

    /// Label text font.
    public var labelTextFont: Font = .body

    /// Label text `DynamicTypeSize` type.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var labelTextDynamicTypeSizeType: DynamicTypeSizeType?

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
    public var labelImageColors: StateColors? = .init(
        enabled: Color.blue,
        pressed: Color.platformDynamic(Color.blue.opacity(0.3), Color.blue.opacity(0.5)),
        disabled: Color.platformDynamic(Color.blue.opacity(0.3), Color.blue.opacity(0.5))
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

    // MARK: Properties - Hit Box
    /// Hit box.
    public var hitBox: EdgeInsets = .init()

    // MARK: Properties - Transition - State Change
    /// Indicates if button animates state change.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var animatesStateChange: Bool = true

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
