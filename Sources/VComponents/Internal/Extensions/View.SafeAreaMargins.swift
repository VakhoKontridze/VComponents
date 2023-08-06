//
//  View.SafeAreaMargins.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 06.08.23.
//

import SwiftUI

// MARK: - Safe Area Margins
@available(macOS, unavailable)
@available(watchOS, unavailable)
extension View {
    @ViewBuilder func safeAreaMargins(
        edges: Edge.Set = .all,
        safeAreaInsets: EdgeInsets
    ) -> some View {
#if canImport(UIKit) && !os(watchOS)
        self
            .padding(.leading, edges.contains(.leading) ? safeAreaInsets.leading : 0)
            .padding(.trailing, edges.contains(.trailing) ? safeAreaInsets.trailing : 0)
            .padding(.top, edges.contains(.top) ? safeAreaInsets.top : 0)
            .padding(.bottom, edges.contains(.bottom) ? safeAreaInsets.bottom : 0)
#endif
    }
}
