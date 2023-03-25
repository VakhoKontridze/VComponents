//
//  VContextMenuContentView.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 22.06.22.
//

import SwiftUI

// MARK: - V Menu Content View
@available(iOS 15.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
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
                    title: section.title,
                    content: { section.makeBody() }
                )
            }
        )
    }
}

// MARK: - Preview
#if DEBUG
import VCore
#endif

@available(iOS 15.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct VContextMenuContentView_Previews: PreviewProvider {
    // Configuration
    private static var colorScheme: ColorScheme { .light }

    // Previews
    static var previews: some View {
        Group(content: {
            Preview().previewDisplayName("*")
        })
            .colorScheme(colorScheme)
    }
    
    // Data
    private enum PickerRow: Int, StringRepresentableHashableEnumeration {
        case red, green, blue

        var stringRepresentation: String {
            switch self {
            case .red: return "Red"
            case .green: return "Green"
            case .blue: return "Blue"
            }
        }
    }

    // Previews (Scenes)
    private struct Preview: View {
        @State private var selection: PickerRow = .red

        var body: some View {
            PreviewContainer(content: {
                Text("Lorem ipsum")
                    .vContextMenu(sections: {
                        VMenuGroupSection(title: "Section 1", rows: {
                            VMenuTitleRow(action: { print("1.1") }, title: "One")
                            VMenuTitleIconRow(action: { print("1.2") }, title: "Two", systemIcon: "swift")
                        })

                        VMenuGroupSection(title: "Section 2", rows: {
                            VMenuTitleRow(action: { print("2.1") }, title: "One")

                            VMenuTitleIconRow(action: { print("2.2") }, title: "Two", systemIcon: "swift")

                            VMenuSubMenuRow(title: "Three...", sections: {
                                VMenuGroupSection(rows: {
                                    VMenuTitleRow(action: { print("2.3.1") }, title: "One")
                                    VMenuTitleIconRow(action: { print("2.3.2") }, title: "Two", systemIcon: "swift")
                                })
                            })
                        })

                        VMenuPickerSection(selection: $selection)
                    })
            })
        }
    }
}
