//
//  VWrappedIndicatorStaticPagerTabViewUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 01.09.23.
//

import SwiftUI
import VCore

// MARK: - V Static Pager Tab View UI Model (Wrapped Indicator)
/// Model that describes UI.
@available(iOS 14.0, *)
@available(macOS 11.0, *)@available(macOS, unavailable)
@available(tvOS 14.0, *)@available(tvOS, unavailable)
@available(watchOS 8.0, *)@available(watchOS, unavailable)
public struct VWrappedIndicatorStaticPagerTabViewUIModel {
    // MARK: Properties - Global Layout
    /// Spacing between tab bar and tab view. Set to `0`.
    public var tabBarAndTabViewSpacing: CGFloat = GlobalUIModel.Containers.pagerTabViewTabBarAndTabViewSpacing

    // MARK: Properties - Header
    /// Header background color.
    public var headerBackgroundColor: Color = GlobalUIModel.Containers.pagerTabViewBackgroundColor

    // MARK: Properties - Tab Bar
    /// Tab bar alignment for tab items. Set to `top`.
    public var tabBarAlignment: VerticalAlignment = GlobalUIModel.Containers.pagerTabViewTabBarAlignment

    // MARK: Properties - Tab Bar - Tab Item
    /// Tab bar margins. Set to `10`s.
    public var tabItemMargins: VerticalMargins = GlobalUIModel.Containers.pagerTabViewTabItemMargins

    // MARK: Properties - Tab Bar - Tab Item - Text
    /// Tab item text minimum scale factor. Set to `0.75`.
    public var tabItemTextMinimumScaleFactor: CGFloat = GlobalUIModel.Common.minimumScaleFactor

    /// Tab item text colors.
    public var tabItemTextColors: TabItemStateColors = .init(
        enabled: GlobalUIModel.Containers.pagerTabViewTabItemTextColorEnabled,
        pressed: GlobalUIModel.Containers.pagerTabViewTabItemTextColorPressed,
        disabled: GlobalUIModel.Containers.pagerTabViewTabItemTextColorDisabled
    )

    /// Tab item text font. Set to `body` (`17`).
    public var tabItemTextFont: Font = GlobalUIModel.Containers.pagerTabViewTabItemTextFont

    // MARK: Properties - Tab Bar - Tab Indicator
    /// Tab indicator height. Set to `2`.
    public var tabIndicatorHeight: CGFloat = GlobalUIModel.Containers.pagerTabViewTabIndicatorHeight

    /// Tab indicator corner radius. Set to `0`.
    public var tabIndicatorCornerRadius: CGFloat = GlobalUIModel.Containers.pagerTabViewTabIndicatorCornerRadius

    /// Tab indicator color.
    public var tabIndicatorColor: Color = GlobalUIModel.Containers.pagerTabViewTabIndicatorColor

    /// Tab indicator track color.
    public var tabIndicatorTrackColor: Color = GlobalUIModel.Containers.pagerTabViewTabIndicatorTrackColor

    /// Tab indicator animation. Set to `default`.
    public var tabIndicatorAnimation: Animation? = GlobalUIModel.Containers.pagerTabViewTabIndicatorAnimation

    // MARK: Properties - Tab View
    /// Tab view background color.
    public var tabViewBackgroundColor: Color = GlobalUIModel.Containers.pagerTabViewBackgroundColor

    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    // MARK: Vertical Margins
    /// Model that contains `top` and `bottom` margins.
    public typealias VerticalMargins = EdgeInsets_TopBottom

    // MARK: Tab Item State Colors
    /// Model that contains colors for component states.
    public typealias TabItemStateColors = GenericStateModel_EnabledPressedDisabled<Color>
}
