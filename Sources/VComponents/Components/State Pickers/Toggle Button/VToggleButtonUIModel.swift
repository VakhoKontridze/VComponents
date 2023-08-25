//
//  VToggleButtonUIModel.swift
//  VComponent
//
//  Created by Vakhtang Kontridze on 25.08.23.
//

import SwiftUI
import VCore

// MARK: - V Toggle Button UI Model
/// Model that describes UI.
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct VToggleButtonUIModel {
    // MARK: Properties - Global Layout
    /// Height.
    /// Set to `32` on `iOS`.
    /// Set to `32` on `macOS`.
    public var height: CGFloat = GlobalUIModel.Buttons.heightCapsuleButton

    // MARK: Properties - Corners
    /// Corner radius. Set to half of `height`.
    public var cornerRadius: CGFloat { height/2 }

    // MARK: Properties - Background
    /// Background colors.
    public var backgroundColors: StateColors = .init(
        off: ColorBook.layerGray,
        on: ColorBook.controlLayerBlue,
        pressedOff: ColorBook.layerGrayPressed,
        pressedOn: ColorBook.controlLayerBluePressed,
        disabled: ColorBook.layerGrayDisabled
    )

    /// Ratio to which background scales down on press.
    /// Set to `1` on `iOS`.
    /// Set to `1` on `macOS`.
    public var backgroundPressedScale: CGFloat = GlobalUIModel.Buttons.pressedScale

    // MARK: Properties - Border
    /// Border width. Set to `0`.
    ///
    /// To hide border, set to `0`.
    public var borderWidth: CGFloat = 0

    /// Border colors.
    public var borderColors: StateColors = .clearColors

    // MARK: Properties - Label
    /// Ratio to which label scales down on press.
    /// Set to `1` on `iOS`.
    /// Set to `1` on `macOS`.
    /// Set to `0.98` on `watchOS`.
    public var labelPressedScale: CGFloat = GlobalUIModel.Buttons.pressedScale

    /// Spacing between icon and title text. Set to `8`.
    ///
    /// Applicable only if icon `init` with icon and title is used.
    public var iconAndTitleTextSpacing: CGFloat = GlobalUIModel.Buttons.iconAndTitleTextSpacing

    /// Label margins. Set to `15` horizontal and `3` vertical.
    public var labelMargins: LabelMargins = GlobalUIModel.Buttons.labelMargins

    // MARK: Properties - Label - Text
    /// Title text minimum scale factor. Set to `0.75`.
    public var titleTextMinimumScaleFactor: CGFloat = GlobalUIModel.Common.minimumScaleFactor

    /// Title text colors.
    public var titleTextColors: StateColors = .init(
        off: ColorBook.primaryBlack,
        on: ColorBook.primaryWhite,
        pressedOff: ColorBook.primaryBlack,
        pressedOn: ColorBook.primaryWhite,
        disabled: ColorBook.primaryBlackPressedDisabled
    )

    /// Title text font.
    /// Set to `semibold` `subheadline` (`15`) on `iOS`.
    /// Set to `semibold` `body` (`13`) on `macOS`.
    public var titleTextFont: Font = GlobalUIModel.Buttons.titleTextFontCapsuleButton

    // MARK: Properties - Label - Icon
    /// Icon size.
    /// Set to `16x16` on `iOS`.
    /// Set to `16x16` on `macOS`.
    public var iconSize: CGSize = GlobalUIModel.Buttons.iconSizeCapsuleButton

    /// Icon colors.
    ///
    /// Applied to all images. But should be used for vector images.
    /// In order to use bitmap images, set this to `clear`.
    public var iconColors: StateColors = .init(
        off: ColorBook.primaryBlack,
        on: ColorBook.primaryWhite,
        pressedOff: ColorBook.primaryBlack,
        pressedOn: ColorBook.primaryWhite,
        disabled: ColorBook.primaryBlackPressedDisabled
    )

    /// Icon opacities. Set to `1`s.
    ///
    /// Applied to all images. But should be used for bitmap images.
    /// In order to use vector images, set this to `1`s.
    public var iconOpacities: StateOpacities = .init(1)

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
    /// One use-case for this property is to externally mutate state using `withAnimation(_:_:)` function.
    public var appliesStateChangeAnimation: Bool = true

    /// State change animation. Set to `easeIn` with duration `0.1`.
    public var stateChangeAnimation: Animation? = GlobalUIModel.StatePickers.stateChangeAnimation

    // MARK: Properties - Haptic
#if os(iOS)
    /// Haptic feedback style. Set to `light`.
    public var haptic: UIImpactFeedbackGenerator.FeedbackStyle? = GlobalUIModel.StatePickers.hapticIOS
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
