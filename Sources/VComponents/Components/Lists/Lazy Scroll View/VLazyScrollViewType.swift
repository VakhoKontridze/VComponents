//
//  VLazyScrollViewType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import Foundation

// MARK: - V Lazy Scroll View Type
/// Model that represents `VLazyScrollView `type, such as `vertical` or `horizontal`.
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
        uiModel: VLazyScrollViewVerticalUIModel = .init()
    ) -> Self {
        .init(lazyScrollViewType: .vertical(
            uiModel: uiModel
        ))
    }
    
    /// Horizontal layout.
    public static func horizontal(
        uiModel: VLazyScrollViewHorizontalUIModel = .init()
    ) -> Self {
        .init(lazyScrollViewType: .horizontal(
            uiModel: uiModel
        ))
    }
    
    /// Default value. Set to `vertical`.
    public static var `default`: Self { .vertical() }
}

// MARK: - V Lazy Scroll View Type
enum _VLazyScrollViewType {
    case vertical(uiModel: VLazyScrollViewVerticalUIModel)
    case horizontal(uiModel: VLazyScrollViewHorizontalUIModel)
}
