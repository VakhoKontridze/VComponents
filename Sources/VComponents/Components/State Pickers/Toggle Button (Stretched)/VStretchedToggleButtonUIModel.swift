//
//  VStretchedToggleButtonUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 25.08.23.
//

import SwiftUI
import VCore

// MARK: - V Stretched Toggle Button UI Model
/// Model that describes UI.
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct VStretchedToggleButtonUIModel {
    // MARK: Properties - Global
    var baseButtonSubUIModel: SwiftUIBaseButtonUIModel {
        var uiModel: SwiftUIBaseButtonUIModel = .init()

        // This flag is what makes the component possible.
        // Animation can be handled within the component,
        // at a cost of sacrificing tap animation.
        uiModel.animatesStateChange = false

        return uiModel
    }
    /// Height.
    /// Set to `48` on `iOS`.
    /// Set to `40` on `macOS`.
    public var height: CGFloat = {
#if os(iOS)
        48
#elseif os(macOS)
        40
#else
        fatalError() // Not supported
#endif
    }()

    // MARK: Properties - Corners
    /// Corner radius.
    /// Set to `14` on `iOS`.
    /// Set to `12` on `macOS`.
    public var cornerRadius: CGFloat = {
#if os(iOS)
        14
#elseif os(macOS)
        12
#else
        fatalError() // Not supported
#endif
    }()

    // MARK: Properties - Background
    /// Background colors.
    public var backgroundColors: StateColors = {
#if os(iOS)
        StateColors(
            off: Color.dynamic(Color(235, 235, 235), Color(60, 60, 60)),
            on: Color.dynamic(Color(24, 126, 240), Color(25, 131, 255)),
            pressedOff: Color.dynamic(Color(220, 220, 220), Color(90, 90, 90)),
            pressedOn: Color.dynamic(Color(31, 104, 182), Color(36, 106, 186)),
            disabled: Color.dynamic(Color(245, 245, 245), Color(50, 50, 50))
        )
#elseif os(macOS)
        StateColors(
            off: Color.dynamic(Color.black.opacity(0.1), Color.black.opacity(0.15)),
            on: Color.dynamic(Color(24, 126, 240), Color(25, 131, 255)),
            pressedOff: Color.dynamic(Color.black.opacity(0.16), Color.black.opacity(0.3)),
            pressedOn: Color.dynamic(Color(31, 104, 182), Color(36, 106, 186)),
            disabled: Color.dynamic(Color.black.opacity(0.05), Color.black.opacity(0.1))
        )
#else
        fatalError() // Not supported
#endif
    }()

    /// Ratio to which background scales down on press. Se to `1`.
    public var backgroundPressedScale: CGFloat = 1

    // MARK: Properties - Border
    /// Border width. Set to `0`.
    ///
    /// To hide border, set to `0`.
    public var borderWidth: CGFloat = 0

    /// Border colors.
    public var borderColors: StateColors = .clearColors

    // MARK: Properties - Label
    /// Label margins. Set to `(15, 3)`.
    public var labelMargins: LabelMargins = .init(horizontal: 15, vertical: 3)

    /// Title text and icon placement. Set to `iconAndTitle`.
    public var titleTextAndIconPlacement: TitleAndIconPlacement = .iconAndTitle

    /// Spacing between title text and icon. Set to `8`.
    ///
    /// Applicable only if `init` with icon and title is used.
    public var titleTextAndIconSpacing: CGFloat = 8

    /// Ratio to which label scales down on press. Se to `1`.
    public var labelPressedScale: CGFloat = 1

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
    /// Set to `semibold` `callout` on `iOS`.
    /// Set to `semibold` `16` on `macOS`.
    public var titleTextFont: Font = {
#if os(iOS)
        Font.callout.weight(.semibold)
#elseif os(macOS)
        Font.system(size: 16, weight: .semibold) // No dynamic type on `macOS`
#else
        fatalError() // Not supported
#endif
    }()

    /// Title text `DynamicTypeSize` type. Set to partial range through `accessibility2`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var titleTextDynamicTypeSizeType: DynamicTypeSizeType? = .partialRangeThrough(...(.accessibility2))

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
    /// Set to `(18, 18)` on `iOS`.
    /// Set to `(16, 16)` on `macOS`.
    public var iconSize: CGSize? = {
#if os(iOS)
        CGSize(dimension: 18)
#elseif os(macOS)
        CGSize(dimension: 16)
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

    /// Icon `DynamicTypeSize` type. Set to `nil`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var iconDynamicTypeSizeType: DynamicTypeSizeType?

    // MARK: Properties - Transition - State Change
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

    // MARK: Properties - Shadow
    /// Shadow colors.
    public var shadowColors: StateColors = .clearColors

    /// Shadow radius. Set to `0`.
    public var shadowRadius: CGFloat = 0

    /// Shadow offset. Set to `zero`.
    public var shadowOffset: CGPoint = .zero

    // MARK: Properties - Haptic
#if os(iOS)
    /// Haptic feedback style. Set to `light`.
    public var haptic: UIImpactFeedbackGenerator.FeedbackStyle? = .light
#endif

    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    // MARK: Label Margins
    /// Model that contains `horizontal` and `vertical` margins.
    public typealias LabelMargins = EdgeInsets_HorizontalVertical

    // MARK: State Colors
    /// Model that contains colors for component states.
    public typealias StateColors = GenericStateModel_OffOnPressedDisabled<Color>

    // MARK: State Opacities
    /// Model that contains opacities for component states.
    public typealias StateOpacities = GenericStateModel_OffOnPressedDisabled<CGFloat>
}
