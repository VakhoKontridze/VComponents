//
//  VModalHeaderLabel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 4/16/22.
//

import SwiftUI

// MARK: - V Modal Header Label
enum VModalHeaderLabel<CustomHeaderLabel> where CustomHeaderLabel: View {
    // MARK: Cases
    case empty
    case title(title: String)
    case custom(label: () -> CustomHeaderLabel)
    
    // MARK: Properties
    var hasLabel: Bool {
        switch self {
        case .empty: return false
        case .title: return true
        case .custom: return true
        }
    }
}
