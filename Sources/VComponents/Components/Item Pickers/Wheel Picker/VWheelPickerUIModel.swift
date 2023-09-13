//
//  VWheelPickerUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import SwiftUI
import VCore

// MARK: - V Wheel Picker UI Model
/// Model that describes UI.
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct VWheelPickerUIModel {
    // MARK: Properties - Global Layout
    /// Spacing between header, picker, and footer. Set to `3`.
    public var headerPickerAndFooterSpacing: CGFloat = GlobalUIModel.Common.headerComponentAndFooterSpacing

    // MARK: Properties - Corners
    /// Picker corner radius. Set to `15`.
    public var cornerRadius: CGFloat = 15

    // MARK: Properties - Background
    /// Background colors.
    public var backgroundColors: StateColors = .init(ColorBook.background)

    // MARK: Properties - Header
    /// Header title text line type. Set to `multiline` with `leading` alignment and `1...2` lines.
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

    /// Header footer horizontal margin. Set to `10`.
    public var headerMarginHorizontal: CGFloat = GlobalUIModel.Common.headerAndFooterMarginHorizontal

    // MARK: Properties - Footer
    /// Footer title text line type. Set to `multiline` with `leading` alignment and `1...5` lines.
    public var footerTitleTextLineType: TextLineType = GlobalUIModel.Common.footerTitleTextLineType

    /// Footer title text colors.
    public var footerTitleTextColors: StateColors = .init(
        enabled: ColorBook.secondary,
        disabled: ColorBook.secondaryPressedDisabled
    )

    /// Footer title text font. Set to `footnote` (`13`).
    public var footerTitleTextFont: Font = GlobalUIModel.Common.footerTitleTextFont

    /// Footer horizontal margin. Set to `10`.
    public var footerMarginHorizontal: CGFloat = GlobalUIModel.Common.headerAndFooterMarginHorizontal

    // MARK: Properties - Rows
    /// Row title text minimum scale factor. Set to `0.75`.
    public var rowTitleTextMinimumScaleFactor: CGFloat = GlobalUIModel.Common.minimumScaleFactor

    /// Row title text colors.
    public var rowTitleTextColors: StateColors = .init(
        enabled: ColorBook.primary,
        disabled: ColorBook.primaryPressedDisabled
    )

    /// Row title text font. Set to `body` (`17`).
    public var rowTitleTextFont: Font = .body
    
    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    // MARK: State Colors
    /// Model that contains colors for component states.
    public typealias StateColors = GenericStateModel_EnabledDisabled<Color>

    // MARK: State Opacities
    /// Model that contains opacities for component states.
    public typealias StateOpacities = GenericStateModel_EnabledDisabled<CGFloat>
}
