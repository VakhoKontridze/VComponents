//
//  VBaseTitleType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/14/21.
//

import SwiftUI

// MARK:- V Base Title Type
/// Enum that describes layout, such as one-line or multi-line
public enum VBaseTitleType {
    case oneLine
    case multiLine(limit: Int?, alignment: TextAlignment)
}
