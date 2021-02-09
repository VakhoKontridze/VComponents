//
//  VTextFieldType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/20/21.
//

import Foundation

// MARK:- V Text Field Type
/// Enum that describes type, such as standard, secure, or search
public enum VTextFieldType: Int, CaseIterable {
    /// Standard textfield
    case standard
    
    /// Secure textfield
    ///
    /// Visibility icon is present, and securities, such as copying is enabled
    case secure
    
    /// Search textfield
    ///
    /// Magnification icon is present
    case search
    
    /// Default value. Set to `standard`.
    public static let `default`: Self = .standard
    
    var isStandard: Bool {
        switch self {
        case .standard: return true
        case .secure: return false
        case .search: return false
        }
    }
    
    var isSecure: Bool {
        switch self {
        case .standard: return false
        case .secure: return true
        case .search: return false
        }
    }
    
    var isSearch: Bool {
        switch self {
        case .standard: return false
        case .secure: return false
        case .search: return true
        }
    }
}
