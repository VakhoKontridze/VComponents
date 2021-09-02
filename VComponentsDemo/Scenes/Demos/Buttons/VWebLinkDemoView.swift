//
//  VWebLinkDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 2/7/21.
//

import SwiftUI
import VComponents

// MARK:- V Web Link Demo View
struct VWebLinkDemoView: View {
    // MARK: Properties
    static let navBarTitle: String = "Web Link"
    
    @State private var state: VWebLinkState = .enabled
    @State private var webLinkButtonType: VWebLinkButtonTypeHelper = .secondary
}

// MARK:- Body
extension VWebLinkDemoView {
    var body: some View {
        VBaseView(title: Self.navBarTitle, content: {
            DemoView(component: component, settings: settings)
        })
    }
    
    @ViewBuilder private func component() -> some View {
        switch webLinkButtonType.preset {
        case let preset?: VWebLink(preset: preset, state: state, url: url, title: buttonTitle)
        case nil: VWebLink(state: state, url: url, content: buttonContent)
        }
    }
    
    @ViewBuilder private func settings() -> some View {
        VSegmentedPicker(selection: $state, headerTitle: "State")
        
        VWheelPicker(selection: $webLinkButtonType, headerTitle: "Preset")
    }
    
    private var buttonTitle: String {
        switch webLinkButtonType.preset {
        case .square: return "Lorem"
        default: return "Lorem ipsum"
        }
    }
    
    private func buttonContent() -> some View { DemoIconContentView(dimension: 20) }
    
    private var url: URL? { .init(string: "https://www.apple.com") }
}

// MARK:- Helpers
extension VWebLinkState: VPickableTitledItem {
    public var pickerTitle: String {
        switch self {
        case .enabled: return "Enabled"
        case .disabled: return "Disabled"
        @unknown default: fatalError()
        }
    }
}

private enum VWebLinkButtonTypeHelper: Int, VPickableTitledItem {
    case primary
    case secondary
    case square
    case plain
    case custom
    
    var preset: VWebLinkPreset? {
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

extension VWebLinkPreset {
    fileprivate var helperType: VWebLinkButtonTypeHelper {
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
struct VWebLinkDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VWebLinkDemoView()
    }
}
