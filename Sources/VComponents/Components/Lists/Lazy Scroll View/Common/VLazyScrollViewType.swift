//
//  VLazyScrollViewType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import Foundation

// MARK: - V Lazy Scroll View Type
/// Model that describes `VLazyScrollView `type, such as `vertical` or `horizontal`.
public struct VLazyScrollViewType {
    // MARK: Properties
    let _lazyScrollViewType: _VLazyScrollViewType
    
    // MARK: Initializers
    private init(
        lazyScrollViewType: _VLazyScrollViewType
    ) {
        self._lazyScrollViewType = lazyScrollViewType
    }
    
    /// Vertical layout.
    public static func vertical(
        model: VLazyScrollViewVerticalModel = .init()
    ) -> Self {
        .init(lazyScrollViewType: .vertical(
            model: model
        ))
    }
    
    /// Horizontal layout.
    public static func horizontal(
        model: VLazyScrollViewHorizontalModel = .init()
    ) -> Self {
        .init(lazyScrollViewType: .horizontal(
            model: model
        ))
    }
    
    /// Default value. Set to `vertical`.
    public static var `default`: Self { .vertical() }
}

// MARK: - V Lazy Scroll View Type
enum _VLazyScrollViewType {
    case vertical(model: VLazyScrollViewVerticalModel)
    case horizontal(model: VLazyScrollViewHorizontalModel)
}
