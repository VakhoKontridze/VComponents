//
//  VStretchedIndicatorStaticPagerTabViewTabItemLabel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 01.09.23.
//

import SwiftUI

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
    case custom(builder: (VStretchedIndicatorStaticPagerTabViewTabItemInternalState, Element) -> CustomTabItemLabel)
}
