//
//  ChevronDirection.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/23/20.
//

import Foundation

// MARK: - Chevron Direction
enum ChevronDirection {
    // MARK: Cases
    case up
    case right
    case down
    case left
    
    // MARK: Properties
    var angle: Double {
        switch self {
        case .up: return 0
        case .right: return 90
        case .down: return 180
        case .left: return -90
        }
    }
}
