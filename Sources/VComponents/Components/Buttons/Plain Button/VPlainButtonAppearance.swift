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
    /// Title text and icon placement.
    public var titleTextAndIconPlacement: TitleAndIconPlacement = .iconAndTitle

    /// Spacing between title text and icon.
    ///
    /// Applicable only if `init` with icon and title is used.
    public var titleTextAndIconSpacing: CGFloat = 8

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
    /// Title text minimum scale factor.
    public var titleTextMinimumScaleFactor: CGFloat = 0.75

    /// Title text colors.
    public var titleTextColors: StateColors = .init(
        enabled: Color.blue,
        pressed: Color.platformDynamic(Color.blue.opacity(0.3), Color.blue.opacity(0.5)),
        disabled: Color.platformDynamic(Color.blue.opacity(0.3), Color.blue.opacity(0.5))
    )

    /// Title text font.
    public var titleTextFont: Font = .body

    /// Title text `DynamicTypeSize` type.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var titleTextDynamicTypeSizeType: DynamicTypeSizeType?

    // MARK: Properties - Label - Icon
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
#elseif os(macOS)
        CGSize(dimension: 14)
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
        enabled: Color.blue,
        pressed: Color.platformDynamic(Color.blue.opacity(0.3), Color.blue.opacity(0.5)),
        disabled: Color.platformDynamic(Color.blue.opacity(0.3), Color.blue.opacity(0.5))
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
