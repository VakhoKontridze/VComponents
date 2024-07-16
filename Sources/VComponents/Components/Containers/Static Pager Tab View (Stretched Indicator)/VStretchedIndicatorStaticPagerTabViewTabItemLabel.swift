//
//  VStretchedIndicatorStaticPagerTabViewTabItemLabel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 01.09.23.
//

import SwiftUI

// MARK: - V Stretched-Indicator Static Pager Tab View Tab Item Label
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
enum VStretchedIndicatorStaticPagerTabViewTabItemLabel<Element, CustomTabItemLabel>
    where
        Element: Hashable,
        CustomTabItemLabel: View
{
    case title(title: (Element) -> String)
    case custom(custom: (VStretchedIndicatorStaticPagerTabViewTabItemInternalState, Element) -> CustomTabItemLabel)
}
