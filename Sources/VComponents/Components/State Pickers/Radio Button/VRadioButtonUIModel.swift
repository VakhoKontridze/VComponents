//
//  VRadioButtonUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import SwiftUI
import VCore

// MARK: - V Radio Button UI Model
/// Model that describes UI.
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct VRadioButtonUIModel {
    // MARK: Properties - Global Layout
    /// Radio button dimension. Set to `16`.
    public var dimension: CGFloat = GlobalUIModel.StatePickers.dimension

    /// Spacing between radio button and label. Set to `0`.
    public var radioButtonAndLabelSpacing: CGFloat = 0

    // MARK: Properties - Fill
    /// Fill colors.
    public var fillColors: StateColors = .init(ColorBook.layer)

    // MARK: Properties - Border
    /// Radio button corner radius. Set to `1`.
    public var borderWidth: CGFloat = 1

    /// Border colors.
    public var borderColors: StateColors = .init(
        off: ColorBook.borderGray,
        on: ColorBook.controlLayerBlue,
        pressedOff: ColorBook.borderGrayPressed,
        pressedOn: ColorBook.controlLayerBluePressed,
        disabled: ColorBook.borderGrayDisabled
    )

    // MARK: Properties - Bullet
    /// Bullet dimension. Set to `8`.
    public var bulletDimension: CGFloat = 8

    /// Bullet colors.
    public var bulletColors: StateColors = .init(
        off: .clear,
        on: ColorBook.controlLayerBlue,
        pressedOff: .clear,
        pressedOn: ColorBook.controlLayerBluePressed,
        disabled: .clear
    )

    // MARK: Properties - Label
    /// Indicates if label is clickable. Set to `true`.
    public var labelIsClickable: Bool = true

    // MARK: Properties - Label - Text
    /// Title text line type. Set to `multiline` with `leading` alignment and `1...2` lines.
    public var titleTextLineType: TextLineType = GlobalUIModel.StatePickers.titleTextLineType

    /// Title text minimum scale factor. Set to `1`.
    public var titleTextMinimumScaleFactor: CGFloat = 1

    /// Title text colors.
    public var titleTextColors: StateColors = .init(
        off: GlobalUIModel.StatePickers.titleColor,
        on: GlobalUIModel.StatePickers.titleColor,
        pressedOff: GlobalUIModel.StatePickers.titleColor,
        pressedOn: GlobalUIModel.StatePickers.titleColor,
        disabled: GlobalUIModel.StatePickers.titleColorDisabled
    )

    /// Title text font.
    /// Set to `subheadline` (`15`) on `iOS`.
    /// Set to `body` (`13`) on `macOS`.
    public var titleTextFont: Font = GlobalUIModel.StatePickers.font

    // MARK: Properties - Hit Box
    /// Radio button hit box. Set to `5`s.
    public var radioButtonHitBox: HitBox = .init(GlobalUIModel.StatePickers.componentAndLabelSpacing) // Actual spacing is 0

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

    /// Model that contains `leading`, `trailing`, `top` and `bottom` hit boxes.
    public typealias HitBox = EdgeInsets_LeadingTrailingTopBottom

    // MARK: State Colors
    /// Model that contains colors for component states.
    public typealias StateColors = GenericStateModel_OffOnPressedDisabled<Color>
}
