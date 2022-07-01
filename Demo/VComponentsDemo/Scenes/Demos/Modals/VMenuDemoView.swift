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
    @State private var selection: PickerRow = .red

    // MARK: Body
    var body: some View {
        DemoView(component: component, settings: settings)
            .standardNavigationTitle(Self.navBarTitle)
    }
    
    private func component() -> some View {
        VMenu(title: "Present", sections: sections)
            .disabled(!isEnabled)
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
    
    @VMenuSectionBuilder private func sections() -> [any VMenuSection] {
        VMenuGroupSection(title: "Section 1", rows: {
            VMenuTitleRow(action: {}, title: "One")
            VMenuTitleIconRow(action: {}, title: "Two", systemIcon: "swift")
        })
        
        VMenuGroupSection(title: "Section 2", rows: {
            VMenuTitleRow(action: {}, title: "One")
            
            VMenuTitleIconRow(action: {}, title: "Two", systemIcon: "swift")
            
            VMenuSubMenuRow(title: "Three...", sections: {
                VMenuGroupSection(rows: {
                    VMenuTitleRow(action: {}, title: "One")
                    VMenuTitleIconRow(action: {}, title: "Two", systemIcon: "swift")
                })
            })
        })
    }
}

// MARK: - Helpers
private typealias VMenuState = VSecondaryButtonInternalState

private enum PickerRow: Int, PickableTitledEnumeration {
    case red, green, blue

    var pickerTitle: String {
        switch self {
        case .red: return "Red"
        case .green: return "Green"
        case .blue: return "Blue"
        }
    }
}

// MARK: - Preview
struct VMenuDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VMenuDemoView()
    }
}
