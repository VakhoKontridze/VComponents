//
//  VTextType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/14/21.
//

import SwiftUI

// MARK: - V Text Type
/// Model that represents text layout, such as `singleLine` or `multiLine`.
public struct VTextType {
    // MARK: Properties
    let _textType: _VTextType
    
    // MARK: Initializers
    private init(
        textType: _VTextType
    ) {
        self._textType = textType
    }
    
    /// Single-line.
    public static var singleLine: Self {
        .init(textType: .singleLine)
    }
    
    /// Multi-line.
    public static func multiLine(
        alignment: TextAlignment,
        lineLimit: Int?
    ) -> Self {
        .init(textType: .multiLine(
            alignment: alignment,
            lineLimit: lineLimit
        ))
    }
}

// MARK: - _ V Text Type
enum _VTextType {
    case singleLine
    case multiLine(alignment: TextAlignment, lineLimit: Int?)
}
