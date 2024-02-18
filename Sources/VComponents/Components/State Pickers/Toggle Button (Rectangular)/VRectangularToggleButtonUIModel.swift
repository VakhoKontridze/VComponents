//
//  VRectangularToggleButtonUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 25.08.23.
//

import SwiftUI
import VCore

// MARK: - V Rectangular Toggle Button UI Model
/// Model that describes UI.
@available(tvOS, unavailable)
@available(visionOS, unavailable)
public struct VRectangularToggleButtonUIModel {
    // MARK: Properties - Global
    var baseButtonSubUIModel: SwiftUIBaseButtonUIModel {
        var uiModel: SwiftUIBaseButtonUIModel = .init()

        // This flag is what makes the component possible.
        // Animation can be handled within the component,
        // at a cost of sacrificing tap animation.
        uiModel.animatesStateChange = false

        return uiModel
    }

    /// Size.
    /// Set to `(56, 56)` on `iOS`.
    /// Set to `(28, 28)` on `macOS`.
    /// Set to `(64, 56)` on `watchOS`.
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
    /// Set to `16` on `iOS`.
    /// Set to `6` on `macOS`.
    /// Set to `16` on `watchOS`.
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
    public var backgroundColors: StateColors = {
#if os(iOS)
        StateColors(
            off: Color.dynamic(Color(235, 235, 235, 1), Color(60, 60, 60, 1)),
            on: Color.dynamic(Color(24, 126, 240, 1), Color(25, 131, 255, 1)),
            pressedOff: Color.dynamic(Color(220, 220, 220, 1), Color(90, 90, 90, 1)),
            pressedOn: Color.dynamic(Color(31, 104, 182, 1), Color(36, 106, 186, 1)),
            disabled: Color.dynamic(Color(245, 245, 245, 1), Color(50, 50, 50, 1))
        )
#elseif os(macOS)
        StateColors(
            off: Color.dynamic(Color.black.opacity(0.1), Color.black.opacity(0.15)),
            on: Color.dynamic(Color(24, 126, 240, 1), Color(25, 131, 255, 1)),
            pressedOff: Color.dynamic(Color.black.opacity(0.16), Color.black.opacity(0.3)),
            pressedOn: Color.dynamic(Color(31, 104, 182, 1), Color(36, 106, 186, 1)),
            disabled: Color.dynamic(Color.black.opacity(0.05), Color.black.opacity(0.1))
        )
#elseif os(watchOS)
        StateColors(
            off: Color(60, 60, 60, 1),
            on: Color(25, 131, 255, 1),
            pressedOff: Color(90, 90, 90, 1),
            pressedOn: Color(36, 106, 186, 1),
            disabled: Color(50, 50, 50, 1)
        )
#else
        fatalError() // Not supported
#endif
    }()

    /// Ratio to which background scales down on press.
    /// Set to `1` on `iOS`.
    /// Set to `1` on `macOS`.
    /// Set to `0.98` on `watchOS`.
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
    /// Border width. Set to `0`.
    ///
    /// To hide border, set to `0`.
    public var borderWidth: CGFloat = 0

    /// Border colors.
    public var borderColors: StateColors = .clearColors

    // MARK: Properties - Label
    /// Label margins. Set to `(3, 3)`.
    public var labelMargins: LabelMargins = .init(3)

    /// Ratio to which label scales down on press.
    /// Set to `1` on `iOS`.
    /// Set to `1` on `macOS`.
    /// Set to `0.98` on `watchOS`.
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
    /// Title text minimum scale factor. Set to `0.75`.
    public var titleTextMinimumScaleFactor: CGFloat = 0.75

    /// Title text colors.
    public var titleTextColors: StateColors = .init(
        off: Color.primary,
        on: Color.white,
        pressedOff: Color.primary,
        pressedOn: Color.white,
        disabled: Color.primary.opacity(0.3)
    )

    /// Title text font.
    /// Set to `semibold` `subheadline` on `iOS`.
    /// Set to `body` on `macOS`.
    /// Set to `semibold` `body` on `watchOS`.
    public var titleTextFont: Font = {
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

    let titleTextDynamicTypeSizeMax: DynamicTypeSize = .accessibility3

    // MARK: Properties - Label - Icon
    /// Indicates if `resizable(capInsets:resizingMode)` modifier is applied to icon. Set to `true`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var isIconResizable: Bool = true

    /// Icon content mode. Set to `fit`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var iconContentMode: ContentMode? = .fit

    /// Icon size.
    /// Set to `(24, 24)` on `iOS`.
    /// Set to `(14, 14)` on `macOS`.
    /// Set to `(26, 26)` on `watchOS`.
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
        off: Color.primary,
        on: Color.white,
        pressedOff: Color.primary,
        pressedOn: Color.white,
        disabled: Color.primary.opacity(0.3)
    )

    /// Icon opacities. Set to `nil`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var iconOpacities: StateOpacities?

    /// Icon font. Set to `nil.`
    ///
    /// Can be used for setting different weight to SF symbol icons.
    /// To achieve this, `isIconResizable` should be set to `false`, and `iconSize` should be set to `nil`.
    public var iconFont: Font?

    // MARK: Properties - Hit Box
    /// Hit box. Set to `zero`.
    public var hitBox: HitBox = .zero

    // MARK: Properties - Shadow
    /// Shadow colors.
    public var shadowColors: StateColors = .clearColors

    /// Shadow radius. Set to `0`.
    public var shadowRadius: CGFloat = 0

    /// Shadow offset. Set to `zero`.
    public var shadowOffset: CGPoint = .zero

    // MARK: Properties - Transition
    /// Indicates if `stateChange` animation is applied. Set to `true`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    ///
    /// If  animation is set to `nil`, a `nil` animation is still applied.
    /// If this property is set to `false`, then no animation is applied.
    ///
    /// One use-case for this property is to externally mutate state using `withAnimation(_:completionCriteria:_:completion:)` function.
    public var appliesStateChangeAnimation: Bool = true

    /// State change animation. Set to `easeIn` with duration `0.1`.
    public var stateChangeAnimation: Animation? = .easeIn(duration: 0.1)

    // MARK: Properties - Haptic
#if os(iOS)
    /// Haptic feedback style. Set to `light`.
    public var haptic: UIImpactFeedbackGenerator.FeedbackStyle? = .light
#elseif os(watchOS)
    /// Haptic feedback type. Set to `click`.
    public var haptic: WKHapticType? = .click
#endif

    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    // MARK: Label Margins
    /// Model that contains `horizontal` and `vertical` margins.
    public typealias LabelMargins = EdgeInsets_HorizontalVertical

    // MARK: Hit Box
    /// Model that contains `leading`, `trailing`, `top` and `bottom` hit boxes.
    public typealias HitBox = EdgeInsets_LeadingTrailingTopBottom

    // MARK: State Colors
    /// Model that contains colors for component states.
    public typealias StateColors = GenericStateModel_OffOnPressedDisabled<Color>

    // MARK: State Opacities
    /// Model that contains opacities for component states.
    public typealias StateOpacities = GenericStateModel_OffOnPressedDisabled<CGFloat>
}
