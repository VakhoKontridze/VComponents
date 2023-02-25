//
//  VPageIndicatorType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/6/21.
//

import Foundation

// MARK: - V Page Indicator Type
/// Model that represents `VPageIndicator` type, such as `finite` or `infinite`.
///
/// 1. `Finite`.
/// Finite number of dots would be displayed.
///
/// 2. `Infinite`.
/// Infinite dots are possible, but only dots specified by `visible` will be displayed.
/// Dots are scrollable in carousel effect, and have scaling property to indicate more content.
/// `visible` and `center` dots must be odd.
///
/// 3. `Auto`.
/// Switches from `finite` to `infinite` after a `finiteLimit`.
public struct VPageIndicatorType {
    // MARK: Properties
    let _pageIndicatorType: _VPageIndicatorType
    
    // MARK: Initializers
    private init(
        pageIndicatorType: _VPageIndicatorType
    ) {
        self._pageIndicatorType = pageIndicatorType
    }
    
    /// Finite type.
    ///
    /// Finite number of dots would be displayed.
    public static func finite(
        uiModel: VPageIndicatorFiniteUIModel = .init()
    ) -> Self {
        .init(pageIndicatorType: .finite(
            uiModel: uiModel
        ))
    }
    
    /// Infinite type.
    ///
    /// Infinite dots are possible, but only dots specified by `visible` will be displayed.
    /// Dots are scrollable in carousel effect, and have scaling property to indicate more content.
    /// `visible` and `center` dots must be odd.
    public static func infinite(
        uiModel: VPageIndicatorInfiniteUIModel = .init()
    ) -> Self {
        .init(pageIndicatorType: .infinite(
            uiModel: uiModel
        ))
    }
    
    /// Automatic type.
    ///
    /// Switches from `finite` to `infinite` after a `finiteLimit`.
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
    case finite(uiModel: VPageIndicatorFiniteUIModel)
    case infinite(uiModel: VPageIndicatorInfiniteUIModel)
    case automatic(uiModel: VPageIndicatorAutomaticUIModel)
}
