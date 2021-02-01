//
//  VMenuDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 2/1/21.
//

import SwiftUI
import VComponents

// MARK:- V Menu Demo View
struct VMenuDemoView: View {
    // MARK: Properties
    static let navigationBarTitle: String = "Menu"
    
    @State private var state: VMenuState = .enabled
}

// MARK:- Body
extension VMenuDemoView {
    var body: some View {
        VBaseView(title: Self.navigationBarTitle, content: {
            DemoView(component: component, settings: settings)
        })
    }
    
    private func component() -> some View {
        VMenu(
            preset: .secondary(),
            state: state,
            rows: [
                .buttonSystemIcon(action: {}, title: "One", name: "swift"),
                .buttonAssetIcon(action: {}, title: "Two", name: "Favorites"),
                .button(action: {}, title: "Three"),
                .button(action: {}, title: "Four"),
                .menu(title: "Five...", rows: [
                    .button(action: {}, title: "One"),
                    .button(action: {}, title: "Two"),
                    .button(action: {}, title: "Three"),
                    .menu(title: "Four...", rows: [
                        .button(action: {}, title: "One"),
                        .button(action: {}, title: "Two"),
                    ])
                ])
            ],
            title: "Present"
        )
    }
    
    @ViewBuilder private func settings() -> some View {
        VSegmentedPicker(selection: $state, headerTitle: "State")
    }
}

// MARK:- Helpers
//extension VMenuState: VPickableTitledItem {
//}

// MARK:- Preview
struct VMenuDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VMenuDemoView()
    }
}
