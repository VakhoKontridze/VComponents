//
//  VBaseHeaderFooterType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/25/21.
//

import SwiftUI

// MARK: - V Base Header Footer Frame Type
/// Enum that represents `VBaseHeaderFooter` frame type, such as `fixed` or `flexible`.
public enum VBaseHeaderFooterFrameType {
    /// Fixed frame.
    case fixed
    
    /// Flexible frame.
    case flexible(_ alignment: HorizontalAlignment)
}

extension HorizontalAlignment {
    var asAlignment: Alignment {
        switch self {
        case .center: return .center
        case .leading: return .leading
        case .trailing: return .trailing
        default: return .center
        }
    }
}
