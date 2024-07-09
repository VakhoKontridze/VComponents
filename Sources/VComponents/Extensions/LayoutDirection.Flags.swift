//
//  LayoutDirection.Flags.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 07.10.23.
//

import SwiftUI

// MARK: - Layout Direction Flags
extension LayoutDirection {
    var isLeftToRight: Bool {
        switch self {
        case .leftToRight: true
        case .rightToLeft: false
        @unknown default: fatalError()
        }
    }

    var isRightToLeft: Bool {
        switch self {
        case .leftToRight: false
        case .rightToLeft: true
        @unknown default: fatalError()
        }
    }
}
