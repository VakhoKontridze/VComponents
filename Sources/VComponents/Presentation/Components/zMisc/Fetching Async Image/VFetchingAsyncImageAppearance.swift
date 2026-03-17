//
//  VFetchingAsyncImageAppearance.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 10.03.23.
//

import SwiftUI

/// Model that describes appearance.
public struct VFetchingAsyncImageAppearance {
    // MARK: Properties
    /// Placeholder color.
    public var placeholderColor: Color = .gray.opacity(0.3)

    /// Indicates if `Image` is removed when parameter changes.
    public var removesImageOnParameterChange: Bool = true

    /// Indicates if `Image` is removed when component disappears.
    public var removesImageOnDisappear: Bool = false
    
    // MARK: Initializers
    /// Initializes appearance with default values.
    public init() {}
}
