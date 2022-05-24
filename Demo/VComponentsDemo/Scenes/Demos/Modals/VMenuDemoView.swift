//
//  VMenuDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 2/1/21.
//

import SwiftUI
import VComponents

// MARK: - V Menu Demo View
struct VMenuDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "Menu" }
    
    @State private var isEnabled: Bool = true

    // MARK: Body
    var body: some View {
        DemoView(component: component, settings: settings)
            .standardNavigationTitle(Self.navBarTitle)
    }
    
    private func component() -> some View {
        VMenu(
            rows: rows,
            label: {
                VPlainButton(
                    action: {},
                    title: "Present"
                )
            }
        )
    }
    
    @ViewBuilder private func settings() -> some View {
        VSegmentedPicker(
            selection: .init(
                get: { VMenuState(isEnabled: isEnabled) },
                set: { isEnabled = $0 == .enabled }
            ),
            headerTitle: "State"
        )
    }
    
    private var rows: [VMenuRow] {
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
private typealias VMenuState = VSecondaryButtonInternalState

// MARK: - Preview
struct VMenuDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VMenuDemoView()
    }
}
