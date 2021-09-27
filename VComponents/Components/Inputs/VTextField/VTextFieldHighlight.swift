//
//  VTextFieldHighlight.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import Foundation

// MARK: - V Text Field Highlight
/// State that describes highlight state, such as `none`, `success`, or `error`
public enum VTextFieldHighlight: Int, CaseIterable {
    /// No highlight
    case none
    
    /// Success highlight with green accent
    case success
    
    /// Error highlight with red accent
    case error
    
    /// Default value. Set to `none`.
    public static var `default`: Self { .none }
}
