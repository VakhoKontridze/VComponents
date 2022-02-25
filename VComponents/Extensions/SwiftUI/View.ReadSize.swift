//
//  View.ReadSize.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 10/28/21.
//

import SwiftUI

// MARK: - Read Size
extension View {
    /// Reads `View` size and calls an on-change block.
    ///
    /// Usage Example:
    ///
    ///     @State private var size: CGSize = .zero
    ///
    ///     var body: some View {
    ///         VStack(content: {
    ///             Color.accentColor
    ///                 .readSize(onChange: { size = $0 })
    ///         })
    ///     }
    ///
    public func readSize(
        onChange completion: @escaping (CGSize) -> Void
    ) -> some View {
        background(
            GeometryReader(content: { proxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: proxy.size)
            })
        )
            .onPreferenceChange(SizePreferenceKey.self, perform: completion)
    }
}

// MARK: - Size Preference Key
private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
