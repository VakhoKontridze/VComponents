//
//  VLazyScrollViewType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import Foundation

// MARK:- V Lazy Scroll View Type
/// Enum of types, such as `vertical` or `horizontal`
public enum VLazyScrollViewType {
    /// Vertical layout
    case vertical(_ model: VLazyScrollViewModelVertical = .init())
    
    /// Horizontal layout
    case horizontal(_ model: VLazyScrollViewModelHorizontal = .init())
    
    /// Default value. Set to `vertical`.
    public static let `default`: Self = .vertical()
}
