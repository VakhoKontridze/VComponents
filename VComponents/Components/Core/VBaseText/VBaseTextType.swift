//
//  VBaseTextType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/14/21.
//

import SwiftUI

// MARK:- V Base Text Type
/// Enum that describes layout, such as one-line or multi-line
public enum VBaseTextType {
    case oneLine
    case multiLine(limit: Int?, alignment: TextAlignment)
}
