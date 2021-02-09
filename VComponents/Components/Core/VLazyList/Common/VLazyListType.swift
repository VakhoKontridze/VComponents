//
//  VLazyListType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import Foundation

// MARK:- V Lazy List Type
/// Enum of types, such as `vertical` or `horizontal`
public enum VLazyListType {
    /// Vertical layout
    case vertical(_ model: VLazyListModelVertical = .init())
    
    /// Horizontal layout
    case horizontal(_ model: VLazyListModelHorizontal = .init())
    
    /// Default value. Set to `vertical`.
    public static let `default`: Self = .vertical()
}
