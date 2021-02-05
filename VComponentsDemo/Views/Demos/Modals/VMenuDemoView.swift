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
    @State private var menuButtonType: VNavigationLinkButtonTypeHelper = .secondary
}

// MARK:- Body
extension VMenuDemoView {
    var body: some View {
        VBaseView(title: Self.navigationBarTitle, content: {
            DemoView(component: component, settings: settings)
        })
    }
    
    @ViewBuilder private func component() -> some View {
        switch menuButtonType.preset {
        case let preset?:
            VMenu(
                preset: preset,
                state: state,
                rows: rows,
                title: buttonTitle
            )
        
        case nil:
            VMenu(
                state: state,
                rows: rows,
                label: buttonContent
            )
        }
    }
    
    @ViewBuilder private func settings() -> some View {
        VSegmentedPicker(selection: $state, headerTitle: "State")
        
        VWheelPicker(selection: $menuButtonType, headerTitle: "Preset")
    }
    
    private var rows: [VMenuRow] {
        [
            .titledSystemIcon(action: {}, title: "One", name: "swift"),
            .titledAssetIcon(action: {}, title: "Two", name: "Favorites"),
            .titled(action: {}, title: "Three"),
            .titled(action: {}, title: "Four"),
            .menu(title: "Five...", rows: [
                .titled(action: {}, title: "One"),
                .titled(action: {}, title: "Two"),
                .titled(action: {}, title: "Three"),
                .menu(title: "Four...", rows: [
                    .titled(action: {}, title: "One"),
                    .titled(action: {}, title: "Two"),
                ])
            ])
        ]
    }
    
    private var buttonTitle: String { "Present" }

    private func buttonContent() -> some View { DemoIconContentView() }
}

// MARK:- Helpers
extension VMenuState: VPickableTitledItem {
    public var pickerTitle: String {
        switch self {
        case .enabled: return "Enabled"
        case .disabled: return "Disabled"
        }
    }
}

// MARK:- Preview
struct VMenuDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VMenuDemoView()
    }
}
