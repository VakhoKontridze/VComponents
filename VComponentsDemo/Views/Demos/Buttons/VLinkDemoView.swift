//
//  VLinkDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 2/7/21.
//

import SwiftUI
import VComponents

// MARK:- V  Link Demo View
struct VLinkDemoView: View {
    // MARK: Properties
    static let navBarTitle: String = "Link"
    
    @State private var state: VLinkState = .enabled
    @State private var linkButtonType: VLinkButtonTypeHelper = .secondary
}

// MARK:- Body
extension VLinkDemoView {
    var body: some View {
        VBaseView(title: Self.navBarTitle, content: {
            DemoView(component: component, settings: settings)
        })
    }
    
    @ViewBuilder private func component() -> some View {
        switch linkButtonType.preset {
        case let preset?: VLink(preset: preset, state: state, url: url, title: buttonTitle)
        case nil: VLink(state: state, url: url, label: buttonContent)
        }
    }
    
    @ViewBuilder private func settings() -> some View {
        VSegmentedPicker(selection: $state, headerTitle: "State")
        
        VWheelPicker(selection: $linkButtonType, headerTitle: "Preset")
    }
    
    private var buttonTitle: String {
        switch linkButtonType.preset {
        case .square: return "Lorem"
        default: return "Lorem ipsum"
        }
    }
    
    private func buttonContent() -> some View { DemoIconContentView(dimension: 20) }
    
    private var url: URL? { URL(string: "https://www.apple.com") }
}

// MARK:- Helpers
extension VLinkState: VPickableTitledItem {
    public var pickerTitle: String {
        switch self {
        case .enabled: return "Enabled"
        case .disabled: return "Disabled"
        @unknown default: fatalError()
        }
    }
}

private enum VLinkButtonTypeHelper: Int, VPickableTitledItem {
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

private extension VLinkPreset {
    var helperType: VLinkButtonTypeHelper {
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
struct VLinkDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VLinkDemoView()
    }
}
