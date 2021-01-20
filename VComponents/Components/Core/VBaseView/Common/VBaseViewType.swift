//
//  VBaseViewType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import Foundation

// MARK:- V Base View Type
/// Enum that describes types, such as centeredTitle or leadingTitle
public enum VBaseViewType: Int, CaseIterable {
    case centerTitle
    case leadingTitle
    
    public static let `default`: Self = .leadingTitle
}
