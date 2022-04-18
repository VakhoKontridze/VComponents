//
//  VLazyScrollViewType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import Foundation

// MARK: - V Lazy Scroll View Type
/// Enum of types, such as `vertical` or `horizontal`.
public enum VLazyScrollViewType {
    // MARK: Cases
    /// Vertical layout.
    case vertical(_ model: VLazyScrollViewVerticalModel = .init())
    
    /// Horizontal layout.
    case horizontal(_ model: VLazyScrollViewHorizontalModel = .init())
    
    // MARK: Initailizers
    /// Default value. Set to `vertical`.
    public static var `default`: Self { .vertical() }
}
