//
//  LayoutDirection+Flags.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 07.10.23.
//

import SwiftUI
import OSLog

extension LayoutDirection {
    var isLeftToRight: Bool {
        switch self {
        case .leftToRight: return true
        case .rightToLeft: return false
        @unknown default:
            Logger.misc.fault("Unhandled 'LayoutDirection' '\(String(describing: self))' in 'LayoutDirection.isLeftToRight'")
            return true
        }
    }

    var isRightToLeft: Bool {
        switch self {
        case .leftToRight: return false
        case .rightToLeft: return true
        @unknown default:
            Logger.misc.fault("Unhandled 'LayoutDirection' '\(String(describing: self))' in 'LayoutDirection.isRightToLeft'")
            return false
        }
    }
}
