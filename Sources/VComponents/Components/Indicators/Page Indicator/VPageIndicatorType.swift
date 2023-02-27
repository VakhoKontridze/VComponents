//
//  VPageIndicatorType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/6/21.
//

import Foundation

// MARK: - V Page Indicator Type
/// Model that represents `VPageIndicator` type, such as `standard` or `compact`.
public struct VPageIndicatorType {
    // MARK: Properties
    let _pageIndicatorType: _VPageIndicatorType
    
    // MARK: Initializers
    private init(
        pageIndicatorType: _VPageIndicatorType
    ) {
        self._pageIndicatorType = pageIndicatorType
    }
    
    /// Standard type.
    public static func standard(
        uiModel: VPageIndicatorStandardUIModel = .init()
    ) -> Self {
        .init(pageIndicatorType: .standard(
            uiModel: uiModel
        ))
    }
    
    /// Compact type.
    ///
    /// Only limited number of dots will be visible, determined by `visibleDots` from the UI model.
    /// Dots are scrollable in carousel effect, and have scaling property to indicate more content.
    public static func compact(
        uiModel: VPageIndicatorCompactUIModel = .init()
    ) -> Self {
        .init(pageIndicatorType: .compact(
            uiModel: uiModel
        ))
    }
    
    /// Automatic type.
    ///
    /// Switches from `standard` to `compact` after a `compactDotLimit` from UI model.
    public static func automatic(
        uiModel: VPageIndicatorAutomaticUIModel = .init()
    ) -> Self {
        .init(pageIndicatorType: .automatic(
            uiModel: uiModel
        ))
    }
    
    /// Default value. Set to `automatic`.
    public static var `default`: Self { .automatic() }
}

// MARK: - _ V Page Indicator Type
enum _VPageIndicatorType {
    case standard(uiModel: VPageIndicatorStandardUIModel)
    case compact(uiModel: VPageIndicatorCompactUIModel)
    case automatic(uiModel: VPageIndicatorAutomaticUIModel)
}
