//
//  VToggleUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI
import VCore

// MARK: - V Toggle UI Model
/// Model that describes UI.
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct VToggleUIModel {
    // MARK: Properties - Global Layout
    /// Toggle size.
    /// Set to `51x32` on `iOS`, similarly to native toggle.
    /// Set to `38x22` on `macOS`, similarly to native toggle.
    public var size: CGSize = {
#if os(iOS)
        CGSize(width: 51, height: 31)
#elseif os(macOS)
        CGSize(width: 38, height: 22)
#else
        fatalError() // Not supported
#endif
    }()

    /// Spacing between toggle and label. Set to `5`.
    public var toggleAndLabelSpacing: CGFloat = GlobalUIModel.StatePickers.componentAndLabelSpacing

    // MARK: Properties - Corners
    var cornerRadius: CGFloat { size.height }

    // MARK: Properties - Fill
    /// Fill colors.
    public var fillColors: StateColors = .init(
        off: ColorBook.layerGray,
        on: ColorBook.controlLayerBlue,
        pressedOff: ColorBook.layerGrayPressed,
        pressedOn: ColorBook.controlLayerBluePressed,
        disabled: ColorBook.layerGrayDisabled
    )

    // MARK: Properties - Thumb
    /// Thumb dimension.
    /// Set to `27` on `iOS`, similarly to native toggle.
    /// Set to `20` on `macOS`, similarly to native toggle.
    public var thumbDimension: CGFloat = {
#if os(iOS)
        27
#elseif os(macOS)
        20
#else
        fatalError() // Not supported
#endif
    }()

    /// Thumb colors.
    public var thumbColors: StateColors = .init(ColorBook.white)

    var thumbOffset: CGFloat {
        let spacing: CGFloat = (size.height - thumbDimension)/2
        let thumbStartPoint: CGFloat = (size.width - thumbDimension)/2
        let offset: CGFloat = thumbStartPoint - spacing
        return offset
    }

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

    // MARK: State Colors
    /// Model that contains colors for component states.
    public typealias StateColors = GenericStateModel_OffOnPressedDisabled<Color>
}
