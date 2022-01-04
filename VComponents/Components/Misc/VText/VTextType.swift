//
//  VTextType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/14/21.
//

import SwiftUI

// MARK: - V Text Type
/// Enum that describes layout, such as `oneLine` or `multiLine`.
public enum VTextType {
    /// One-line.
    case oneLine
    
    /// Multi-line.
    case multiLine(alignment: TextAlignment, limit: Int?)
}
