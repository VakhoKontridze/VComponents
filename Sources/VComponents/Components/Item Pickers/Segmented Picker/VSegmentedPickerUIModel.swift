//
//  VSegmentedPickerUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/7/21.
//

import SwiftUI
import VCore

// MARK: - V Segmented Picker UI Model
/// Model that describes UI.
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct VSegmentedPickerUIModel {
    // MARK: Properties - General
    /// Height.
    /// Set to `31` on `iOS`, similarly to native segmented picker.
    /// Set to `22` on `macOS`, similarly to native segmented picker.
    public var height: CGFloat = {
#if os(iOS)
        return 31
#elseif os(macOS)
        return 22
#else
        fatalError() // Not supported
#endif
    }()

    /// Corner radius. Set to `7`, similarly to native segmented picker.
    public var cornerRadius: CGFloat = 7

    /// Spacing between header text, picker, and footer text. Set to `3`.
    public var headerPickerAndFooterSpacing: CGFloat = GlobalUIModel.Common.headerComponentAndFooterSpacing

    /// Header and footer horizontal margin. Set to `10`.
    public var headerAndFooterMarginHorizontal: CGFloat = GlobalUIModel.Common.headerAndFooterMarginHorizontal

    // MARK: Properties - Background
    /// Border width.
    /// Set to `0` on `iOS`.
    /// Set to `1` scaled to screen on `macOS`.
    ///
    /// To hide border, set to `0`.
    public var borderWidth: CGFloat = {
#if os(iOS)
        return 0
#elseif os(macOS)
        return 1/MultiplatformConstants.screenScale
#else
        fatalError() // Not supported
#endif
    }()

    /// Background colors.
    public var backgroundColors: StateColors = .init(
        enabled: ColorBook.layerGray,
        disabled: ColorBook.layerGrayDisabled
    )

    // MARK: Properties - Border
    /// Border colors.
    public var borderColors: StateColors = {
#if os(iOS)
        return .clearColors
#elseif os(macOS)
        return StateColors(
            enabled: ColorBook.borderGray,
            disabled: ColorBook.borderGrayDisabled
        )
#else
        fatalError() // Not supported
#endif
    }()

    // MARK: Properties - Header
    /// Header title text line type. Set to `singleLine`.
    public var headerTitleTextLineType: TextLineType = GlobalUIModel.Common.headerTitleTextLineType

    /// Header title text colors.
    public var headerTitleTextColors: StateColors = .init(
        enabled: ColorBook.secondary,
        disabled: ColorBook.secondaryPressedDisabled
    )

    /// Header title text font.
    /// Set to `footnote` (`13`) on `iOS`.
    /// Set to `footnote` (`10`) on `macOS`.
    public var headerTitleTextFont: Font = GlobalUIModel.Common.headerTitleTextFont

    // MARK: Properties - Footer
    /// Footer title text line type. Set to `multiline` with `leading` alignment and `1...5` lines.
    public var footerTitleTextLineType: TextLineType = GlobalUIModel.Common.footerTitleTextLineType

    /// Footer title text colors.
    public var footerTitleTextColors: StateColors = .init(
        enabled: ColorBook.secondary,
        disabled: ColorBook.secondaryPressedDisabled
    )

    /// Footer title text font.
    /// Set to `footnote` (`13`) on `iOS`.
    /// Set to `footnote` (`10`) on `macOS`
    public var footerTitleTextFont: Font = GlobalUIModel.Common.footerTitleTextFont

    // MARK: Properties - Content
    /// Content margin. Set to `2`.
    public var contentMargin: CGFloat = 2

    // MARK: Properties - Rows
    /// Row title text minimum scale factor. Set to `0.75`.
    public var rowTitleTextMinimumScaleFactor: CGFloat = GlobalUIModel.Common.minimumScaleFactor

    /// Row title text colors.
    public var rowTitleTextColors: RowStateColors = .init(
        deselected: ColorBook.primary,
        selected: ColorBook.primary,
        pressedDeselected: ColorBook.primaryPressedDisabled,
        pressedSelected: ColorBook.primary, // Looks better this way
        disabled: ColorBook.primaryPressedDisabled
    )

    /// Row title text font.
    /// Set to `medium` `13` (`footnote`) on `iOS`.
    /// Set to `13` on `macOS`.
    public var rowTitleTextFont: Font = {
#if os(iOS)
        return Font.system(size: 13).weight(.medium) // Prevents scaling, similarly to native picker
#elseif os(macOS)
        return Font.system(size: 13) // No dynamic type on `macOS`
#else
        fatalError() // Not supported
#endif
    }()

    /// Ratio to which selected row content scales down on press.
    /// Set to `0.95` on `iOS`.
    /// Set to `1` on `macOS`
    public var rowContentPressedScale: CGFloat = {
#if os(iOS)
        return 0.95
#elseif os(macOS)
        return 1
#else
        fatalError() // Not supported
#endif
    }()

    // MARK: Properties - Indicator
    /// Selection indicator corner radius.  Set to `6`, similarly to native segmented picker.
    public var indicatorCornerRadius: CGFloat = 6

    /// Selection indicator margin.
    /// Set to `2` on `iOS`.
    /// Set to `1` on `macOS`.
    public var indicatorMargin: CGFloat = {
#if os(iOS)
        return 2
#elseif os(macOS)
        return 1
#else
        fatalError() // Not supported
#endif
    }()

    /// Selection indicator colors.
    public var indicatorColors: IndicatorStateColors = {
#if os(iOS)
        return IndicatorStateColors(
            enabled: Color(module: "SegmentedPicker.Indicator"),
            pressed: Color(module: "SegmentedPicker.Indicator"),
            disabled: Color(module: "SegmentedPicker.Indicator.Disabled")
        )
#elseif os(macOS)
        return IndicatorStateColors(
            enabled: Color(module: "SegmentedPicker.Indicator"),
            pressed: Color(module: "SegmentedPicker.Indicator.Pressed_macOS"),
            disabled: Color(module: "SegmentedPicker.Indicator.Disabled")
        )
#else
        fatalError() // Not supported
#endif
    }()

    /// Indicator press animation.
    /// Set to `linear` with duration `0.2` on `iOS`.
    /// Set to `nil` on `macOS`.
    public var indicatorPressAnimation: Animation? = {
#if os(iOS)
        return Animation.linear(duration: 0.2)
#elseif os(macOS)
        return nil
#else
        fatalError() // Not supported
#endif
    }()

    /// Ratio to which selection indicator scales down on press.
    /// Set to `0.95` on `iOS`.
    /// Set to `1` on `macOS`
    public var indicatorPressedScale: CGFloat = {
#if os(iOS)
        return 0.95
#elseif os(macOS)
        return 1
#else
        fatalError() // Not supported
#endif
    }()

    // MARK: Properties - Indicator Shadow
    /// Selection indicator shadow colors.
    public var indicatorShadowColors: IndicatorStateColors = .init(
        enabled: GlobalUIModel.Common.shadowColorEnabled,
        pressed: GlobalUIModel.Common.shadowColorEnabled,
        disabled: GlobalUIModel.Common.shadowColorDisabled
    )

    /// Indicator shadow radius. Set to `1`.
    public var indicatorShadowRadius: CGFloat = 1

    /// Indicator shadow offset.
    /// Set to `1x1` on `iOS`.
    /// Set to `0x1` on `macOS`.
    public var indicatorShadowOffset: CGPoint = {
#if os(iOS)
        return CGPoint(x: 1, y: 1)
#elseif os(macOS)
        return CGPoint(x: 0, y: 1)
#else
        fatalError() // Not supported
#endif
    }()

    // MARK: Properties - Divider
    /// Row divider size.
    /// Set to `1x19` on `iOS`, similarly to native segmented picker.
    /// Set to `1x13` on `macOS`, similarly to native segmented picker.
    public var dividerSize: CGSize = {
#if os(iOS)
        return CGSize(width: 1, height: 19)
#elseif os(macOS)
        return CGSize(width: 1, height: 12)
#else
        fatalError() // Not supported
#endif
    }()

    /// Row divider colors.
    public var dividerColors: StateColors = .init(
        enabled: GlobalUIModel.Common.dividerDashColorEnabled,
        disabled: GlobalUIModel.Common.dividerDashColorDisabled
    )

    // MARK: Properties - Transition
    /// Indicates if `selection` animation is applied. Set to `true`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    ///
    /// This property doesn't affect internal button press.
    ///
    /// If  animation is set to `nil`, a `nil` animation is still applied.
    /// If this property is set to `false`, then no animation is applied.
    ///
    /// One use-case for this property is to externally mutate state using `withAnimation(_:_:)` function.
    public var appliesSelectionAnimation: Bool = true

    /// State change animation. Set to `easeInOut` with duration `0.2`.
    public var selectionAnimation: Animation? = .easeInOut(duration: 0.2)

    // MARK: Properties - Haptic
#if os(iOS)
        /// Indicates if picker uses haptic feedback. Set to `true`.
        public var usesHaptic: Bool = true
#endif
    
    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    // MARK: State Colors
    /// Model that contains colors for component states.
    public typealias StateColors = GenericStateModel_EnabledDisabled<Color>

    // MARK: Indicator State Colors
    /// Model that contains colors for component states.
    public typealias IndicatorStateColors = GenericStateModel_EnabledPressedDisabled<Color>

    // MARK: Row State Colors
    /// Model that contains colors for component states.
    public typealias RowStateColors = GenericStateModel_DeselectedSelectedPressedDisabled<Color>

    // MARK: State Opacities
    /// Model that contains opacities for component states.
    public typealias RowStateOpacities = GenericStateModel_EnabledPressedDisabled<CGFloat>
}
