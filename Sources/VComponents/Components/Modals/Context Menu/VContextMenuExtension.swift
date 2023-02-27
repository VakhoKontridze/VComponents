//
//  VContextMenuExtension.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 22.06.22.
//

import SwiftUI

// MARK: - Standard Menu
extension View {
    /// Presents context menu when `View` is long-pressed.
    ///
    ///     private enum PickerRow: Int, StringRepresentableHashableEnumeration {
    ///         case red, green, blue
    ///
    ///         var stringRepresentation: String {
    ///             switch self {
    ///             case .red: return "Red"
    ///             case .green: return "Green"
    ///             case .blue: return "Blue"
    ///             }
    ///         }
    ///     }
    ///
    ///     @State private var selection: PickerRow = .red
    ///
    ///     private var body: some View {
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
extension View {
    /// Presents context menu when `View` is long-pressed.
    ///
    ///     private enum PickerRow: Int, StringRepresentableHashableEnumeration {
    ///         case red, green, blue
    ///
    ///         var stringRepresentation: String {
    ///             switch self {
    ///             case .red: return "Red"
    ///             case .green: return "Green"
    ///             case .blue: return "Blue"
    ///             }
    ///         }
    ///     }
    ///
    ///     @State private var selection: PickerRow = .red
    ///
    ///     private var body: some View {
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
    ///                 sections: sections,
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
