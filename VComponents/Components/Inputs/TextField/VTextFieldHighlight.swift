//
//  VTextFieldHighlight.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/19/21.
//

import SwiftUI

// MARK: - V Text Field Highlight
/// State that describes highlight state, such as `none`, `success`, or `error`.
public enum VTextFieldHighlight: Int, CaseIterable {
    // MARK: Cases
    /// No highlight.
    case none
    
    /// Success highlight with green accent.
    case success
    
    /// Error highlight with red accent.
    case error
    
    // MARK: Initailizers
    /// Default value. Set to `none`.
    public static var `default`: Self { .none }
}

// MARK: - Mapping
extension StateColors_EFSEPD {
    func `for`(highlight: VTextFieldHighlight) -> Color {
        switch highlight {
        case .none: return pressedEnabled
        case .success: return pressedSuccess
        case .error: return pressedError
        }
    }
}

extension StateColorsAndOpacities_EFSEPD_PD {
    func `for`(_ state: VTextFieldState, highlight: VTextFieldHighlight) -> Color {
        switch (highlight, state) {
        case (_, .disabled): return disabled
        case (.none, .enabled): return enabled
        case (.none, .focused): return focused
        case (.success, .enabled): return success
        case (.success, .focused): return success
        case (.error, .enabled): return error
        case (.error, .focused): return error
        }
    }
    
    func `for`(highlight: VTextFieldHighlight) -> Color {
        switch highlight {
        case .none: return pressedEnabled
        case .success: return pressedSuccess
        case .error: return pressedError
        }
    }
}
