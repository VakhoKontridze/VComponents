//
//  VContextMenuContentView.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 22.06.22.
//

import SwiftUI
import VCore

// MARK: - V Menu Content View
@available(tvOS, unavailable) // N/A
@available(watchOS, unavailable) // No `View.contextMenu(...)` support
struct VContextMenuContentView: View {
    // MARK: Properties
    private let sections: () -> [any VMenuSectionProtocol]

    // MARK: Initializers
    init(
        @VMenuSectionBuilder sections: @escaping () -> [any VMenuSectionProtocol]
    ) {
        self.sections = sections
    }

    // MARK: Body
    var body: some View {
        ForEach(
            sections().enumeratedArray(),
            id: \.offset,
            content: { (_, section) in
                TitledSection(
                    headerTitle: section.headerTitle,
                    content: { section.makeBody() }
                )
            }
        )
    }
}

// MARK: - Preview
import VCore

// Developmental only
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct VContextMenuContentView_Previews: PreviewProvider {
    // Configuration
    private static var interfaceOrientation: InterfaceOrientation { .portrait }
    private static var languageDirection: LayoutDirection { .leftToRight }
    private static var dynamicTypeSize: DynamicTypeSize? { nil }
    private static var colorScheme: ColorScheme { .light }

    // Previews
    static var previews: some View {
        Group(content: {
            Preview().previewDisplayName("*")
        })
        .previewInterfaceOrientation(interfaceOrientation)
        .environment(\.layoutDirection, languageDirection)
        .applyIfLet(dynamicTypeSize, transform: { $0.dynamicTypeSize($1) })
        .preferredColorScheme(colorScheme)
    }

    // Data
    private enum RGBColor: Int, Hashable, Identifiable, CaseIterable, StringRepresentable {
        case red, green, blue

        var id: Int { rawValue }

        var stringRepresentation: String { .init(describing: self).capitalized.pseudoRTL(languageDirection) }
    }

    // Previews (Scenes)
    private struct Preview: View { // Didn't bother with pseudoRTL
        @State private var selection: RGBColor = .red

        var body: some View {
            PreviewContainer(content: {
                Text("Lorem ipsum")
                    .vContextMenu(
                        sections: {
                            VMenuGroupSection(headerTitle: "Section 1", rows: {
                                VMenuRow(action: {}, title: "One")
                                VMenuRow(action: {}, title: "Two", icon: Image(systemName: "swift"))
                                VMenuExpandingRow(title: "Three...", sections: {
                                    VMenuGroupSection(rows: {
                                        VMenuRow(action: {}, title: "One")
                                        VMenuRow(action: {}, title: "Two", icon: Image(systemName: "swift"))
                                    })
                                })
                            })

                            VMenuPickerSection(selection: $selection)
                        },
                        preview: {
                            ZStack(content: {
                                Color.blue
                                    .frame(width: 300, height: 100)

                                Text("Selection: \(selection.stringRepresentation)")
                                    .foregroundColor(ColorBook.primaryWhite)
                            })
                        }
                    )
            })
        }
    }
}
