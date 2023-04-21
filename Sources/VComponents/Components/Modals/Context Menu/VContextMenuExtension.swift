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
    ///                 VMenuGroupSection(title: "Section 1", rows: {
    ///                     VMenuTitleRow(action: { print("1.1") }, title: "One")
    ///                     VMenuTitleIconRow(action: { print("1.2") }, title: "Two", systemIcon: "swift")
    ///                 })
    ///
    ///                 VMenuGroupSection(title: "Section 2", rows: {
    ///                     VMenuTitleRow(action: { print("2.1") }, title: "One")
    ///
    ///                     VMenuTitleIconRow(action: { print("2.2") }, title: "Two", systemIcon: "swift")
    ///
    ///                     VMenuSubMenuRow(title: "Three...", sections: {
    ///                         VMenuGroupSection(rows: {
    ///                             VMenuTitleRow(action: { print("2.3.1") }, title: "One")
    ///                             VMenuTitleIconRow(action: { print("2.3.2") }, title: "Two", systemIcon: "swift")
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
    ///             .vContextMenu(
    ///                 sections: {
    ///                     VMenuGroupSection(title: "Section 1", rows: {
    ///                         VMenuTitleRow(action: { print("1.1") }, title: "One")
    ///                         VMenuTitleIconRow(action: { print("1.2") }, title: "Two", systemIcon: "swift")
    ///                     })
    ///
    ///                     VMenuGroupSection(title: "Section 2", rows: {
    ///                         VMenuTitleRow(action: { print("2.1") }, title: "One")
    ///
    ///                         VMenuTitleIconRow(action: { print("2.2") }, title: "Two", systemIcon: "swift")
    ///
    ///                         VMenuSubMenuRow(title: "Three...", sections: {
    ///                             VMenuGroupSection(rows: {
    ///                                 VMenuTitleRow(action: { print("2.3.1") }, title: "One")
    ///                                 VMenuTitleIconRow(action: { print("2.3.2") }, title: "Two", systemIcon: "swift")
    ///                             })
    ///                         })
    ///                     })
    ///
    ///                     VMenuPickerSection(selection: $selection)
    ///                 },
    ///                 preview: {
    ///                     ZStack(content: {
    ///                         Color.blue
    ///                             .frame(width: UIScreen.main.bounds.width * 0.9, height: 100)
    ///
    ///                         Text("Selection: \(selection.stringRepresentation)")
    ///                             .foregroundColor(.white)
    ///                     })
    ///                 }
    ///             )
    ///     }
    ///
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
