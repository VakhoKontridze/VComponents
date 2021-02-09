//
//  VTextType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/14/21.
//

import SwiftUI

// MARK:- V Text Type
/// Enum that describes layout, such as one-line or multi-line
public enum VTextType {
    /// One-line
    case oneLine
    
    /// Multi-line
    case multiLine(limit: Int?, alignment: TextAlignment)
}
