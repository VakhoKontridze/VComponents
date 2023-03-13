//
//  GenericLabels.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 01.07.22.
//

import SwiftUI

// MARK: - Generic Label (Title, Custom)
enum GenericLabel_TitleCustom<CustomLabel> where CustomLabel: View {
    case title(title: String)
    case custom(label: () -> CustomLabel)
}

// MARK: - Generic Label (Empty, Title, Custom)
enum GenericLabel_EmptyTitleCustom<CustomLabel>: Equatable where CustomLabel: View {
    case empty
    case title(title: String)
    case custom(label: () -> CustomLabel)
    
    var hasLabel: Bool {
        switch self {
        case .empty: return false
        case .title: return true
        case .custom: return true
        }
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.empty, .empty): return true
        case (.title(let lhs), .title(let rhs)): return lhs == rhs
        default: return false
        }
    }
}

// MARK: - Generic Label (Title, Icon, Custom)
enum GenericLabel_TitleIconCustom<CustomLabel> where CustomLabel: View {
    case title(title: String)
    case icon(icon: Image)
    case custom(label: () -> CustomLabel)
}

// MARK: - Generic Label (Title, Icon Title, Custom)
enum GenericLabel_TitleIconTitleCustom<CustomLabel> where CustomLabel: View {
    case title(title: String)
    case iconTitle(icon: Image, title: String)
    case custom(label: () -> CustomLabel)
}

// MARK: - Generic Label (Title, Icon, Icon Title, Custom)
enum GenericLabel_TitleIconIconTitleCustom<CustomLabel> where CustomLabel: View {
    case title(title: String)
    case icon(icon: Image)
    case iconTitle(icon: Image, title: String)
    case custom(label: () -> CustomLabel)
}
