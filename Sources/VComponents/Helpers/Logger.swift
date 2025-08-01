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
    static let compactPageIndicator: Self = .init("VCompactPageIndicator")
    static let rangeSlider: Self = .init("VRangeSlider")
    static let rollingCounter: Self = .init("VRollingCounter")
    static let wrappedIndicatorStaticPagerTabView: Self = .init("VWrappedIndicatorStaticPagerTabView")
}

extension Logger {
    fileprivate init(_ category: String) {
        self.init(subsystem: "VComponents", category: category)
    }
}
