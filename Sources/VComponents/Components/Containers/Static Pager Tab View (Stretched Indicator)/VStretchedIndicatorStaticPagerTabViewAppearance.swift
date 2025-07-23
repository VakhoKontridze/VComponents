//
//  VStretchedIndicatorStaticPagerTabViewAppearance.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 01.09.23.
//

import SwiftUI
import VCore

// MARK: - V Stretched-Indicator Static Pager Tab View Appearance
/// Model that describes appearance.
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct VStretchedIndicatorStaticPagerTabViewAppearance: Sendable {
    // MARK: Properties - Global
    /// Spacing between tab bar and tab view.
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
    /// Tab bar alignment for tab items.
    public var tabBarAlignment: VerticalAlignment = .top

    // MARK: Properties - Tab Bar - Tab Item
    /// Tab bar margins.
    public var tabItemMargins: EdgeInsetsVertical = .init(10)

    // MARK: Properties - Tab Bar - Tab Item - Text
    /// Tab item text minimum scale factor.
    public var tabItemTextMinimumScaleFactor: CGFloat = 0.75

    /// Tab item text colors.
    public var tabItemTextColors: TabItemStateColors = .init(
        deselected: Color.primary,
        selected: Color.blue,
        pressedDeselected: Color.primary.opacity(0.3),
        pressedSelected: Color.platformDynamic(Color(31, 104, 182), Color(36, 106, 186)),
        disabled: Color.primary.opacity(0.3)
    )

    /// Tab item text font.
    public var tabItemTextFont: Font = .body

    /// Tab item text `DynamicTypeSize` type.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var tabItemTextDynamicTypeSizeType: DynamicTypeSizeType? = .partialRangeThrough(...(.accessibility2))

    // MARK: Properties - Tab Indicator Strip
    /// Tab indicator strip alignment.
    public var tabIndicatorStripAlignment: VerticalAlignment = .bottom

    // MARK: Properties - Tab Indicator Strip - Track
    /// Tab indicator track height.
    public var tabIndicatorTrackHeight: CGFloat = 2

    /// Tab indicator track color.
    public var tabIndicatorTrackColor: Color = .clear

    // MARK: Properties - Tab Indicator Strip - Selection
    /// Selected tab indicator height.
    public var selectedTabIndicatorHeight: CGFloat = 2

    /// Selected tab indicator corner radius.
    public var selectedTabIndicatorCornerRadius: CGFloat = 0

    /// Selected tab indicator color.
    public var selectedTabIndicatorColor: Color = .blue

    /// Selected tab indicator animation.
    public var selectedTabIndicatorAnimation: Animation? = .default

    /// Indicates if tab indicator bounces when content is dragged out of frame.
    public var selectedTabIndicatorBounces: Bool = true

    /// Selected tab indicator horizontal margin.
    public var selectedTabIndicatorMarginHorizontal: CGFloat = 0

    // MARK: Properties - Tab View
    /// Tab view background color.
    public var tabViewBackgroundColor: Color = {
#if os(iOS)
        Color(uiColor: UIColor.systemBackground)
#else
        fatalError() // Not supported
#endif
    }()
    
    /// Indicates if tab view scrolling is enabled.
    public var isTabViewScrollingEnabled: Bool = true

    // MARK: Initializers
    /// Initializes appearance with default values.
    public init() {}

    // MARK: Tab Item State Colors
    /// Model that contains colors for component states.
    public typealias TabItemStateColors = GenericStateModel_DeselectedSelectedPressedDisabled<Color>
}
