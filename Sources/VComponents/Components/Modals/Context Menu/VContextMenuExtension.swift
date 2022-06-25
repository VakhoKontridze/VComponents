//
//  VContextMenuExtension.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 22.06.22.
//

import SwiftUI

// MARK: - V Context Menu Extension
extension View {
    /// Presents context menu when `View` is long-pressed.
    ///
    ///     var body: some View {
    ///         Text("Lorem Ipsum")
    ///             .vContextMenu(rows: [
    ///                 .titleIcon(action: {}, title: "One", assetIcon: "SomeIcon"),
    ///                 .titleIcon(action: {}, title: "Two", icon: someIcon),
    ///                 .titleIcon(action: {}, title: "Three", systemIcon: "swift"),
    ///                 .title(action: {}, title: "Four"),
    ///                 .title(action: {}, title: "Five"),
    ///                 .menu(title: "Five...", rows: [
    ///                     .title(action: {}, title: "One"),
    ///                     .title(action: {}, title: "Two"),
    ///                     .title(action: {}, title: "Three"),
    ///                     .menu(title: "Four...", rows: [
    ///                         .title(action: {}, title: "One"),
    ///                         .title(action: {}, title: "Two")
    ///                    ])
    ///                ])
    ///          ])
    ///     }
    ///
    public func vContextMenu(rows: [VContextMenuRow]) -> some View {
        self
            .contextMenu(menuItems: {
                VContextMenuContentView(rows: rows)
            })
    }
}
