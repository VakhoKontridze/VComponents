//
//  VToastType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/7/21.
//

import SwiftUI

// MARK: - V Toast Type
/// Model that represents toast layout, such as `singleLine` or `multiLine`.
public struct VToastType {
    // MARK: Properties
    let _toastType: _VToastType
    
    // MARK: Initializers
    private init(
        toastType: _VToastType
    ) {
        self._toastType = toastType
    }
    
    /// Single-line.
    public static var singleLine: Self {
        .init(toastType: .singleLine)
    }
    
    /// Multi-line.
    public static func multiLine(
        alignment: TextAlignment,
        lineLimit: Int?
    ) -> Self {
        .init(toastType: .multiLine(
            alignment: alignment,
            lineLimit: lineLimit
        ))
    }
}

// MARK: - _ V Toast Type
enum _VToastType {
    // MARK: Cases
    case singleLine
    case multiLine(alignment: TextAlignment, lineLimit: Int?)
    
    // MARK: Properties
    var toTextType: VTextType {
        switch self {
        case .singleLine:
            return .singleLine
        
        case .multiLine(let alignment, let lineLimit):
            return .multiLine(alignment: alignment, lineLimit: lineLimit)
        }
    }
}
