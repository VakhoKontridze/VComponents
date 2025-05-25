//
//  VWrappedIndicatorStaticPagerTabViewUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 01.09.23.
//

import SwiftUI
import VCore

// MARK: - V Wrapped-Indicator Static Pager Tab View UI Model
/// Model that describes UI.
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct VWrappedIndicatorStaticPagerTabViewUIModel: Sendable {
    // MARK: Properties - Global
    /// Spacing between tab bar and tab view. Set to `0`.
    public var tabBarAndTabViewSpacing: CGFloat = 0

    // MARK: Properties - Header
    /// Header background color.
    public var headerBackgroundColor: Color = {
#if os(iOS)
        Color(uiColor: UIColor.systemBackground)
#else
        fatalError() // Not supported
#endif
    }()

    // MARK: Properties - Tab Bar
    /// Tab bar alignment for tab items. Set to `top`.
    public var tabBarAlignment: VerticalAlignment = .top

    // MARK: Properties - Tab Bar - Tab Item
    /// Tab bar margins. Set to `(10, 10)`.
    public var tabItemMargins: VerticalMargins = .init(10)

    // MARK: Properties - Tab Bar - Tab Item - Text
    /// Tab item text minimum scale factor. Set to `0.75`.
    public var tabItemTextMinimumScaleFactor: CGFloat = 0.75

    /// Tab item text colors.
    public var tabItemTextColors: TabItemStateColors = .init(
        deselected: Color.primary,
        selected: Color.blue,
        pressedDeselected: Color.primary.opacity(0.3),
        pressedSelected: Color.dynamic(Color(31, 104, 182), Color(36, 106, 186)),
        disabled: Color.primary.opacity(0.3)
    )

    /// Tab item text font. Set to `body`.
    public var tabItemTextFont: Font = .body

    /// Tab item text `DynamicTypeSize` type. Set to partial range through `accessibility2`.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var tabItemTextDynamicTypeSizeType: DynamicTypeSizeType? = .partialRangeThrough(...(.accessibility2))

    // MARK: Properties - Tab Indicator Strip
    /// Tab indicator strip alignment. Set to `bottom`.
    public var tabIndicatorStripAlignment: VerticalAlignment = .bottom

    // MARK: Properties - Tab Indicator Strip - Track
    /// Tab indicator track height. Set to `2`.
    public var tabIndicatorTrackHeight: CGFloat = 2

    /// Tab indicator track color.
    public var tabIndicatorTrackColor: Color = .clear

    // MARK: Properties - Tab Indicator Strip - Selection
    /// Selected tab indicator height. Set to `2`.
    public var selectedTabIndicatorHeight: CGFloat = 2

    /// Selected tab indicator corner radius. Set to `0`.
    public var selectedTabIndicatorCornerRadius: CGFloat = 0

    /// Selected tab indicator color.
    public var selectedTabIndicatorColor: Color = .blue

    /// Selected tab indicator animation. Set to `default`.
    public var selectedTabIndicatorAnimation: Animation? = .default

    // MARK: Properties - Tab View
    /// Indicates if tab view scrolling is enabled. Set to `true`.
    public var isTabViewScrollingEnabled: Bool = true
    
    /// Tab view background color.
    public var tabViewBackgroundColor: Color = {
#if os(iOS)
        Color(uiColor: UIColor.systemBackground)
#else
        fatalError() // Not supported
#endif
    }()

    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    // MARK: Vertical Margins
    /// Model that contains `top` and `bottom` margins.
    public typealias VerticalMargins = EdgeInsets_TopBottom

    // MARK: Tab Item State Colors
    /// Model that contains colors for component states.
    public typealias TabItemStateColors = GenericStateModel_DeselectedSelectedPressedDisabled<Color>
}
