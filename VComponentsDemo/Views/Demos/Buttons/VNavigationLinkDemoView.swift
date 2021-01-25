//
//  VNavigationLinkDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 18.12.20.
//

import SwiftUI
import VComponents

// MARK:- V Navigation Link Demo View
struct VNavigationLinkDemoView: View {
    // MARK: Properties
    static let navigationBarTitle: String = "Navigation Link"
    
    @State private var state: VNavigationLinkState = .enabled
    @State private var navigationLinkType: VNavigationLinkTypeHelper = .primary
}

// MARK:- Body
extension VNavigationLinkDemoView {
    var body: some View {
        VBaseView(title: Self.navigationBarTitle, content: {
            DemoView(component: component, settings: settings)
        })
    }
    
    @ViewBuilder private func component() -> some View {
        switch navigationLinkType.preset {
        case let preset?: VNavigationLink(preset: preset, state: state, destination: destination, title: buttonTitle)
        case nil: VNavigationLink(state: state, destination: destination, label: buttonContent)
        }
    }
    
    @ViewBuilder private func settings() -> some View {
        VSegmentedPicker(selection: $state, headerTitle: "State")
        
        VWheelPicker(selection: $navigationLinkType, headerTitle: "Type")
    }
    
    private var buttonTitle: String {
        switch navigationLinkType.preset {
        case .square: return "Lorem"
        default: return "Lorem ipsum"
        }
    }
    
    private func buttonContent() -> some View { DemoIconContentView(dimension: 20) }
    
    private var destination: some View {
        VBaseView(title: "Destination", content: {
            ZStack(content: {
                ColorBook.canvas.edgesIgnoringSafeArea(.all)

                VSheet()
            })
        })
    }
}

// MARK:- Helpers
extension VNavigationLinkState: VPickableTitledItem {
    public var pickerTitle: String {
        switch self {
        case .enabled: return "Enabled"
        case .disabled: return "Disabled"
        }
    }
}

private enum VNavigationLinkTypeHelper: Int, VPickableTitledItem {
    case primary
    case secondary
    case square
    case plain
    case custom
    
    var preset: VNavigationLinkPreset? {
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

private extension VNavigationLinkPreset {
    var helperType: VNavigationLinkTypeHelper {
        switch self {
        case .primary: return .primary
        case .secondary: return .secondary
        case .square: return .square
        case .plain: return .plain
        }
    }
}

// MARK:- Preview
struct VNavigationLinkDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VNavigationLinkDemoView()
    }
}
