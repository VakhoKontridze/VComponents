//
//  VPageIndicatorType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/6/21.
//

import Foundation

// MARK: - V Page Indicator Type
/// Model that describes `VPageIndicator type`, such as `finite` or `infinite`.
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
    public static var finite: Self {
        .init(pageIndicatorType: .finite)
    }
    
    /// Infinite type.
    ///
    /// Infinite dots are possible, but only dots specified by `visible` will be displayed.
    /// Dots are scrollable in carousel effect, and have scaling property to indicate more content.
    /// `visible` and `center` dots must be odd.
    public static func infinite(
        visible: Int = 7,
        center: Int = 3
    ) -> Self {
        .init(pageIndicatorType: .infinite(
            visible: visible,
            center: center
        ))
    }
    
    /// Automatic type.
    ///
    /// Switches from `finite` to `infinite` after a `finiteLimit`.
    public static func automatic(
        visible: Int = 7,
        center: Int = 3,
        finiteLimit: Int = 10
    ) -> Self {
        .init(pageIndicatorType: .automatic(
            visible: visible,
            center: center,
            finiteLimit: finiteLimit
        ))
    }
    
    /// Default value. Set to `automatic`.
    public static var `default`: Self { .automatic() }
}

// MARK: - _ V Page Indicator Type
enum _VPageIndicatorType {
    case finite
    case infinite(visible: Int, center: Int)
    case automatic(visible: Int, center: Int, finiteLimit: Int)
}
