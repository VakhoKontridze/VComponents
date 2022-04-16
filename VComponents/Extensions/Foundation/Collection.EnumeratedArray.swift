//
//  Collection.EnumeratedArray.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/10/21.
//

import Foundation

// MARK: - Enumerated Array
extension Collection {
    /// Enumerated a `Collection` as a tuple of offset and element.
    ///
    /// Element can be used as id in `ForEach` without use of an explicit identifier.
    ///
    /// Usage Example:
    ///
    ///     struct EnumeratedArrayView<Data, Content>: View
    ///         where
    ///             Data: RandomAccessCollection,
    ///             Data.Index == Int,
    ///             Content: View
    ///     {
    ///         let data: Data
    ///         let rowContent: (Data.Element) -> Content
    ///
    ///         var body: some View {
    ///             ForEach(
    ///                 data.enumeratedArray(),
    ///                 id: \.offset,
    ///                 content: { (i, row) in rowContent(row) }
    ///             )
    ///         }
    ///     }
    ///
    public func enumeratedArray() -> Array<(offset: Int, element: Self.Element)> {
        .init(self.enumerated())
    }
}
