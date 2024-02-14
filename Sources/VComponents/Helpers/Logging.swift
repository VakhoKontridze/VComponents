//
//  Logging.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12.02.24.
//

import Foundation
import OSLog

// MARK: - Loggers
extension Logger {
    static let bottomSheet: Self = .init(subsystem: "VComponents", category: "VBottomSheet")
    static let compactPageIndicator: Self = .init(subsystem: "VComponents", category: "VCompactPageIndicator")
    static let rangeSlider: Self = .init(subsystem: "VComponents", category: "VRangeSlider")
    static let rollingCounter: Self = .init(subsystem: "VComponents", category: "VRollingCounter")
    static let wrappedIndicatorStaticPagerTabView: Self = .init(subsystem: "VComponents", category: "VWrappedIndicatorStaticPagerTabView")
}
