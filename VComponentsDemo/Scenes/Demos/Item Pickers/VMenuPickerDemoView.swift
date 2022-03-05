//
//  VMenuPickerDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 2/2/21.
//

import SwiftUI
import VComponents

// MARK: - V Menu Picker Demo View
struct VMenuPickerDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "Menu Picker" }
    
    @State private var selection: VSegmentedPickerDataSource = .red
    @State private var state: VMenuPickerState = .enabled
    @State private var menuPickerButtonType: VMenuPickerButtonTypeHelper = .secondary
    @State private var contentType: VSegmentedPickerContent = .title

    // MARK: Body
    var body: some View {
        DemoView(component: component, settings: settings)
            .standardNavigationTitle(Self.navBarTitle)
    }
    
    @ViewBuilder private func component() -> some View {
        fatalError() // FIXME: Resolve
//        switch (menuPickerButtonType.preset, contentType) {
//        case (let preset?, .title):
//            VMenuPicker(
//                preset: preset,
//                state: state,
//                selection: $selection,
//                title: buttonTitle
//            )
//
//        case (let preset?, .custom):
//            VMenuPicker(
//                preset: preset,
//                state: state,
//                selection: $selection,
//                label: buttonContent
//            )
//
//        case (nil, _):
//            VMenuPicker(
//                state: state,
//                selection: $selection,
//                label: buttonContent
//            )
//        }
    }
    
    @DemoViewSettingsSectionBuilder private func settings() -> some View {
        DemoViewSettingsSection(content: {
            VSegmentedPicker(selection: $state, headerTitle: "State")
        })

        DemoViewSettingsSection(content: {
            VWheelPicker(
                selection: $menuPickerButtonType,
                headerTitle: "Type"
            )
                .onChange(of: menuPickerButtonType, perform: { type in
                    if type == .custom { contentType = .custom }
                })

//            VSegmentedPicker( // FIXME: Resolve
//                selection: $contentType,
//                headerTitle: "Content",
//                disabledItems: menuPickerButtonType == .custom ? [.title] : []
//            )
        })
    }
    
    private var buttonTitle: String {
        fatalError() // FIXME: Resolve
        
//        switch menuPickerButtonType.preset {
//        case .square: return "Lorem"
//        default: return "Lorem Ipsum"
//        }
    }

    private func buttonContent() -> some View { DemoIconContentView() }
}

// MARK: - Helpers
extension VMenuPickerState: PickableTitledEnumeration {
    public var pickerTitle: String {
        switch self {
        case .enabled: return "Enabled"
        case .disabled: return "Disabled"
        @unknown default: fatalError()
        }
    }
}

private enum VMenuPickerButtonTypeHelper: Int, PickableTitledEnumeration {
    case primary
    case secondary
    case square
    case plain
    case custom
    
//    var preset: VWebLinkPreset? {
//        switch self {
//        case .primary: return .primary()
//        case .secondary: return .secondary()
//        case .square: return .square()
//        case .plain: return .plain()
//        case .custom: return nil
//        }
//    }
    
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

extension VMenuButtonPreset {
    fileprivate var helperType: VMenuPickerButtonTypeHelper {
        switch self {
        case .primary: return .primary
        case .secondary: return .secondary
        case .square: return .square
        case .plain: return .plain
        @unknown default: fatalError()
        }
    }
}

// MARK: - Preview
struct VMenuPickerDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VMenuPickerDemoView()
    }
}
