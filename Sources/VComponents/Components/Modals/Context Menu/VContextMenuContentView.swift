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
        .colorScheme(colorScheme)
    }
    
    // Data
    private enum RGBColor: Int, Hashable, Identifiable, CaseIterable, StringRepresentable {
        case red, green, blue

        var id: Int { rawValue }

        var stringRepresentation: String { _stringRepresentation.pseudoRTL(languageDirection) }
        private var _stringRepresentation: String { .init(describing: self).capitalized }
    }
    
    // Previews (Scenes)
    private struct Preview: View { // Didn't bother with pseudoRTL
        @State private var selection: RGBColor = .red
        
        var body: some View {
            PreviewContainer(content: {
                Text("Lorem ipsum")
                    .vContextMenu(
                        sections: {
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
                        },
                        preview: {
                            ZStack(content: {
                                Color.blue
                                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 100)

                                Text("Selection: \(selection.stringRepresentation)")
                                    .foregroundColor(.white)
                            })
                        }
                    )
            })
        }
    }
}
