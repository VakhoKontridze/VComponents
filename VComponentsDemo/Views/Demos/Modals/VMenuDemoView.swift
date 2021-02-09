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
    static let navBarTitle: String = "Menu"
    
    @State private var state: VMenuState = .enabled
    @State private var menuButtonType: VMenuButtonTypeHelper = .secondary
}

// MARK:- Body
extension VMenuDemoView {
    var body: some View {
        VBaseView(title: Self.navBarTitle, content: {
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
        @unknown default: fatalError()
        }
    }
}

private enum VMenuButtonTypeHelper: Int, VPickableTitledItem {
    case primary
    case secondary
    case square
    case plain
    case custom
    
    var preset: VLinkPreset? {
        switch self {
        case .primary: return .primary()
        case .secondary: return .secondary()
        case .square: return .square()
        case .plain: return .plain()
        case .custom: return nil
        }
    }
    
    var pickerTitle: String {
        switch self {
        case .primary: return "Primary"
        case .secondary: return "Secondary"
        case .square: return "Square"
        case .plain: return "Plain"
        case .custom: return "Custom"
        }
    }
}

private extension VMenuButtonPreset {
    var helperType: VMenuButtonTypeHelper {
        switch self {
        case .primary: return .primary
        case .secondary: return .secondary
        case .square: return .square
        case .plain: return .plain
        @unknown default: fatalError()
        }
    }
}

// MARK:- Preview
struct VMenuDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VMenuDemoView()
    }
}
