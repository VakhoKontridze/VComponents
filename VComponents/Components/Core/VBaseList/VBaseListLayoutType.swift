//
//  VGenericListContentLayout.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/11/21.
//

import Foundation

// MARK:- V Base List Layout Type
/// Enum that describes layout, such as fixed or flexible
public enum VBaseListLayoutType: Int, CaseIterable {
    case fixed
    case flexible
    
    public static let `default`: Self = .flexible
}
