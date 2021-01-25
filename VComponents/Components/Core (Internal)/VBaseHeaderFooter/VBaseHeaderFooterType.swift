//
//  VBaseHeaderFooterType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/25/21.
//

import SwiftUI

// MARK:- V Base Header Footer Frame Type
enum VBaseHeaderFooterFrameType {
    case auto
    case flex(_ alignment: HorizontalAlignment)
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
