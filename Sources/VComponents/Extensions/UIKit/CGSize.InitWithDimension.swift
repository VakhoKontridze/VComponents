//
//  CGSize.InitWithDimension.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/26/22.
//

import UIKit

// MARK: - Init Size with Dimension
extension CGSize {
    /// Initialzies `CGSize` with dimension.
    ///
    /// Usage Example:
    ///
    ///     let size: CGSize = .init(dimension: 100)
    ///
    public init(dimension: CGFloat) {
        self.init(
            width: dimension,
            height: dimension
        )
    }
}
