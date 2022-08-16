//
//  VListStyle.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 16.08.22.
//

import SwiftUI

// MARK: - V List Style Extension
extension View {
    /// Applies list style tjat supports `VListRow`.
    public func vListStyle() -> some View {
        self
            .modifier(VListStyle())
    }
}

// MARK: - V List Style
struct VListStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .listStyle(.plain)
            .environment(\.defaultMinListRowHeight, 0)
    }
}
