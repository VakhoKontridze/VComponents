//
//  VTextFieldHighlight.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import Foundation

// MARK:- V Text Field Highlight
/// State that describes highlight state, such as none, success, or error
public enum VTextFieldHighlight: Int, CaseIterable {
    case none
    case success
    case error
    
    public static let `default`: Self = .none
}
