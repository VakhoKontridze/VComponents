//
//  VContextMenuExtension.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 22.06.22.
//

import SwiftUI

// MARK: - Standard Menu
@available(iOS 15.0, macOS 12.0, *)
@available(tvOS 14.0, *)@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {
    /// Presents context menu when `View` is long-pressed.
    ///
    /// Modal component that presents menu of actions, and hosts preview.
    ///
    /// Optionally, preview can be presented with methods that have `preview` argument.
    ///
    ///     private enum RGBColor: Int, Hashable, Identifiable, CaseIterable, StringRepresentable {
    ///         case red, green, blue
    ///
    ///         var id: Int { rawValue }
    ///         var stringRepresentation: String { .init(describing: self).capitalized }
    ///     }
    ///
    ///     @State private var selection: RGBColor = .red
    ///
    ///     var body: some View {
    ///         Text("Lorem Ipsum")
    ///             .vContextMenu(sections: {
    ///                 VMenuGroupSection(headerTitle: "Section 1", rows: {
    ///                     VMenuRow(action: { print("1") }, title: "One")
    ///                     VMenuRow(action: { print("2") }, title: "Two", icon: Image(systemName: "swift"))
    ///                     VMenuExpandingRow(title: "Three...", sections: {
    ///                         VMenuGroupSection(rows: {
    ///                             VMenuRow(action: { print("3.1") }, title: "One")
    ///                             VMenuRow(action: { print("3.2") }, title: "Two", icon: Image(systemName: "swift"))
    ///                         })
    ///                     })
    ///                 })
    ///
    ///                 VMenuPickerSection(selection: $selection)
    ///             })
    ///     }
    ///
    public func vContextMenu(
        @VMenuSectionBuilder sections: @escaping () -> [any VMenuSectionProtocol]
    ) -> some View {
        self
            .contextMenu(menuItems: {
                VContextMenuContentView(sections: sections)
            })
    }
}

// MARK: - Menu with Preview
@available(iOS 16.0, macOS 13.0, *)
@available(tvOS 16.0, *)@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {
    /// Presents context menu when `View` is long-pressed.
    ///
    /// For additional info, refer to `View.vContextMenu(sections:)`.
    public func vContextMenu<PreviewContent>(
        @VMenuSectionBuilder sections: @escaping () -> [any VMenuSectionProtocol],
        preview: () -> PreviewContent
    ) -> some View
        where PreviewContent: View
    {
        self
            .contextMenu(
                menuItems: { VContextMenuContentView(sections: sections) },
                preview: preview
            )
    }
}
