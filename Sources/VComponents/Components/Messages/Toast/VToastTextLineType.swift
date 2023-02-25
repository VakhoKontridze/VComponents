//
//  VToastTextLineType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/7/21.
//

import SwiftUI
import VCore

// MARK: - V Toast Text Line Type
/// Model that represents text line, such as `singleLine` or `multiLine`.
public struct VToastTextLineType {
    // MARK: Properties
    let _toastTextLineType: _VToastTextLineType
    
    // MARK: Initializers
    private init(
        toastTextLineType: _VToastTextLineType
    ) {
        self._toastTextLineType = toastTextLineType
    }
    
    /// Single-line.
    public static var singleLine: Self {
        .init(toastTextLineType: .singleLine)
    }
    
    /// Multi-line.
    public static func multiLine(
        alignment: TextAlignment,
        lineLimit: Int?
    ) -> Self {
        .init(toastTextLineType: .multiLine(
            alignment: alignment,
            lineLimit: lineLimit
        ))
    }
}

// MARK: - _ V Toast Text Line Type
enum _VToastTextLineType {
    // MARK: Cases
    case singleLine
    case multiLine(alignment: TextAlignment, lineLimit: Int?)
    
    // MARK: Properties
    var toTextLineType: TextLineType {
        switch self {
        case .singleLine:
            return .singleLine
        
        case .multiLine(let alignment, let lineLimit):
            return .multiLine(alignment: alignment, lineLimit: lineLimit)
        }
    }
}
