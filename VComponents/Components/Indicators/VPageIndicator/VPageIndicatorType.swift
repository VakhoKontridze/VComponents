//
//  VPageIndicatorType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/6/21.
//

import Foundation

// MARK:- V Page Indicator Type
/// Enum that describes page indicator type, such as finite or infinite
///
/// 1. Finite. Finite number of dots would be displayed.
///
/// 2. Infinite. Infinite dots are possible, but only dots specified by **visible** will be displayed.
/// Dots are scrollable in carousel effect, and have scaling property to indicate more content.
/// If odd **visible** and **center** are not passed, layout would invalidate itself, and refuse to draw.
///
/// 3. Auto. Switches from **finite** to **infinite** after a **finiteLimit**.
public enum VPageIndicatorType {
    case finite
    case infinite(visible: Int = 7, center: Int = 3)
    case auto(visible: Int = 7, center: Int = 3, finiteLimit: Int = 10)
    
    public static let `default`: Self = .auto()
}
