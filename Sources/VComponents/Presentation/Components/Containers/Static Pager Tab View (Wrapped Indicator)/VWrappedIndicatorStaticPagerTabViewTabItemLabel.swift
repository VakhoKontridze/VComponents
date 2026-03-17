//
//  VWrappedIndicatorStaticPagerTabViewTabItemLabel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 01.09.23.
//

import SwiftUI

@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
enum VWrappedIndicatorStaticPagerTabViewTabItemLabel<Element, CustomTabItemLabel>
    where
        Element: Hashable,
        CustomTabItemLabel: View
{
    case title(title: (Element) -> String)
    case custom(builder: (VWrappedIndicatorStaticPagerTabViewTabItemInternalState, Element) -> CustomTabItemLabel)
}
