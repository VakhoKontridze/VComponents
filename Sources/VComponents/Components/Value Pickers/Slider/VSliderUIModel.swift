//
//  VSliderUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/21/20.
//

import SwiftUI
import VCore

// MARK: - V Slider UI Model
/// Model that describes UI.
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct VSliderUIModel {
    // MARK: Properties - Global Layout
    /// Direction. Set to `leftToRight`.
    public var direction: LayoutDirectionOmni = .leftToRight

    /// Slider height, but width for vertical layout. Set to `10`.
    public var height: CGFloat = GlobalUIModel.Common.barHeight

    // MARK: Properties - Corners
    /// Slider corner radius. Set to `5`.
    public var cornerRadius: CGFloat = GlobalUIModel.Common.barCornerRadius

    // MARK: Properties - Body
    /// Indicates if body is draggable.
    /// Set to `false` on `iOS`.
    /// Set to `true` on `macOS`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var bodyIsDraggable: Bool = {
#if os(iOS)
        false
#elseif os(macOS)
        true
#else
        fatalError() // Not supported
#endif
    }()

    // MARK: Properties - Track
    /// Slider track colors.
    public var trackColors: StateColors = .init(
        enabled: ColorBook.layerGray,
        disabled: ColorBook.layerGrayDisabled
    )

    // MARK: Properties - Progress
    /// Slider progress colors.
    public var progressColors: StateColors = .init(
        enabled: ColorBook.accentBlue,
        disabled: ColorBook.accentBluePressedDisabled
    )

    /// Indicates if slider rounds progress view right-edge. Set to `true`.
    ///
    /// For RTL languages, this refers to left-edge.
    public var roundsProgressViewRightEdge: Bool = true

    var progressViewRoundedCorners: RectCorner {
        if roundsProgressViewRightEdge {
            .allCorners
        } else {
            []
        }
    }

    // MARK: Properties - Border
    /// Border width. Set to `0`.
    ///
    /// To hide border, set to `0`.
    public var borderWidth: CGFloat = 0

    /// Border colors.
    public var borderColors: StateColors = .clearColors

    // MARK: Properties - Thumb
    /// Thumb dimension. Set to `20`.
    ///
    /// To hide thumb, set to `0`.
    public var thumbDimension: CGFloat = GlobalUIModel.ValuePickers.sliderThumbDimension

    /// Thumb corner radius. Set to `10`.
    public var thumbCornerRadius: CGFloat = GlobalUIModel.ValuePickers.sliderThumbCornerRadius

    /// Thumb colors.
    public var thumbColors: StateColors = .init(ColorBook.white)

    // MARK: Properties - Thumb Border
    /// Thumb border widths.
    /// Set to `0` on `iOS`.
    /// Set to `1` pixel on `macOS`.
    ///
    /// To hide border, set to `0`.
    public var thumbBorderWidth: PointPixelMeasurement = {
#if os(iOS)
        .points(0)
#elseif os(macOS)
        .pixels(1)
#else
        fatalError() // Not supported
#endif
    }()

    /// Thumb border colors.
    public var thumbBorderColors: StateColors = {
#if os(iOS)
        StateColors.clearColors
#elseif os(macOS)
        StateColors(
            enabled: ColorBook.borderGray,
            disabled: ColorBook.borderGrayDisabled
        )
#else
        fatalError() // Not supported
#endif
    }()

    // MARK: Properties - Thumb Shadow
    /// Thumb shadow colors.
    public var thumbShadowColors: StateColors = .init(
        enabled: GlobalUIModel.Common.shadowColorEnabled,
        disabled: GlobalUIModel.Common.shadowColorDisabled
    )

    /// Thumb shadow radius.
    /// Set to `2` on `iOS`.
    /// Set to `1` on `macOS`.
    public var thumbShadowRadius: CGFloat = GlobalUIModel.ValuePickers.sliderThumbShadowRadius

    /// Thumb shadow offset.
    /// Set to `0x2` on `iOS`.
    /// Set to `0x1` on `macOS`.
    public var thumbShadowOffset: CGPoint = GlobalUIModel.ValuePickers.sliderThumbShadowOffset

    // MARK: Properties - Transition
    /// Indicates if `progress` animation is applied. Set to `true`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    ///
    /// If  animation is set to `nil`, a `nil` animation is still applied.
    /// If this property is set to `false`, then no animation is applied.
    ///
    /// One use-case for this property is to externally mutate state using `withAnimation(_:_:)` function.
    public var appliesProgressAnimation: Bool = true

    /// Progress animation. Set to `nil`.
    public var progressAnimation: Animation? = nil

    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    // MARK: State Colors
    /// Model that contains colors for component states.
    public typealias StateColors = GenericStateModel_EnabledDisabled<Color>
}
