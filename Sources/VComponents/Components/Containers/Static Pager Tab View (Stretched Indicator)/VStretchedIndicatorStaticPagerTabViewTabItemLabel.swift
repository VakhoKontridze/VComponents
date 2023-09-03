//
//  VStretchedIndicatorStaticPagerTabViewTabItemLabel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 01.09.23.
//

import SwiftUI

// MARK: - V Stretched-Indicator Static Pager Tab View Tab Item Label
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
enum VStretchedIndicatorStaticPagerTabViewTabItemLabel<Element, Content>
    where
        Element: Hashable,
        Content: View
{
    case title(title: (Element) -> String)
    case label(label: (VStretchedIndicatorStaticPagerTabViewTabItemInternalState, Element) -> Content)
}
