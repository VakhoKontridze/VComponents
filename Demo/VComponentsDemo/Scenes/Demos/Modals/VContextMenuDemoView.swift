//
//  VContextMenuDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 22.06.22.
//

import SwiftUI
import VComponents

// MARK: - V Menu Demo View
struct VContextMenuDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "Context Menu" }
    
    @State private var isEnabled: Bool = true

    // MARK: Body
    var body: some View {
        DemoView(component: component, settings: settings)
            .standardNavigationTitle(Self.navBarTitle)
    }
    
    private func component() -> some View {
        Text("Present")
            .vContextMenu(rows: rows)
    }
    
    @ViewBuilder private func settings() -> some View {
        VSegmentedPicker(
            selection: .init(
                get: { VContextMenuState(isEnabled: isEnabled) },
                set: { isEnabled = $0 == .enabled }
            ),
            headerTitle: "State"
        )
    }
    
    private var rows: [VContextMenuRow] {
        [
            .titleIcon(action: {}, title: "One", icon: .init(systemName: "swift")),
            .titleIcon(action: {}, title: "Two", systemIcon: "swift"),
            .title(action: {}, title: "Three"),
            .title(action: {}, title: "Four"),
            .menu(title: "Five...", rows: [
                .title(action: {}, title: "One"),
                .title(action: {}, title: "Two"),
                .title(action: {}, title: "Three"),
                .menu(title: "Four...", rows: [
                    .title(action: {}, title: "One"),
                    .title(action: {}, title: "Two")
                ])
            ])
        ]
    }
}

// MARK: - Helpers
private typealias VContextMenuState = VSecondaryButtonInternalState

// MARK: - Preview
struct VContextMenuDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VContextMenuDemoView()
    }
}
