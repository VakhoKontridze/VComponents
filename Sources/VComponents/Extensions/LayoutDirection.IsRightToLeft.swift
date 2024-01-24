//
//  LayoutDirection.IsRightToLeft.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 07.10.23.
//

import SwiftUI

// MARK: - Layout Direction Is Right-to-Left
extension LayoutDirection {
    var isRightToLeft: Bool {
        switch self {
        case .leftToRight: false
        case .rightToLeft: true
        @unknown default: fatalError()
        }
    }
}
