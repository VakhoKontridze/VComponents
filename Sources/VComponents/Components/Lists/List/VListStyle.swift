//
//  VListStyle.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 16.08.22.
//

import SwiftUI

// MARK: - V List Style
@available(iOS 15.0, *)
extension View {
    /// Applies list style that supports `VListRow`.
    public func vListStyle() -> some View {
        self
            .listStyle(.plain)
            .environment(\.defaultMinListRowHeight, 0)
    }
}
