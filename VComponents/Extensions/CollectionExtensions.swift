//
//  CollectionExtensions.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/10/21.
//

import Foundation

// MARK: - Enumerated Colleciton
extension Collection {
    func enumeratedArray() -> Array<(offset: Int, element: Self.Element)> {
        .init(self.enumerated())
    }
}
