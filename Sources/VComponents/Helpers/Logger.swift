//
//  Logger.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12.02.24.
//

import Foundation
import OSLog

extension Logger {
    // MARK: Properties - Views
    static let alert: Self = .init("VAlert")
    static let bottomSheet: Self = .init("VBottomSheet")
    static let bouncingMarquee: Self = .init("VBouncingMarquee")
    static let compactPageIndicator: Self = .init("VCompactPageIndicator")
    static let rangeSlider: Self = .init("VRangeSlider")
    static let rollingCounter: Self = .init("VRollingCounter")
    static let sideBar: Self = .init("VSideBar")
    static let wrappingMarquee: Self = .init("VWrappingMarquee")
    static let wrappedIndicatorStaticPagerTabView: Self = .init("VWrappedIndicatorStaticPagerTabView")
    
    // MARK: Properties - Misc
    static let misc: Self = .init("Misc")
}

extension Logger {
    fileprivate init(_ category: String) {
        self.init(subsystem: "VComponents", category: category)
    }
}
