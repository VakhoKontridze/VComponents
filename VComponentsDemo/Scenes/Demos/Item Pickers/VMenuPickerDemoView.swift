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
    
    @State private var selection: VMenuPickerDataSource = .red
    @State private var isEnabled: Bool = true
    @State private var labelType: VMenuPickerContent = .title

    // MARK: Body
    var body: some View {
        DemoView(component: component, settings: settings)
            .standardNavigationTitle(Self.navBarTitle)
    }
    
    @ViewBuilder private func component() -> some View {
        Group(content: {
            switch labelType {
            case .title:
                VMenuPicker(
                    selection: $selection,
                    label: {
                        VPlainButton(
                            action: {},
                            title: "Lorem Ipsum"
                        )
                    }
                )
            
            case .custom:
                VMenuPicker(
                    selection: $selection,
                    label: {
                        VPlainButton(
                            action: {},
                            title: "Lorem Ipsum"
                        )
                    },
                    rowContent: { .titleIcon(title: $0.pickerTitle, icon: .init(systemName: "swift")) }
                )
            }
        })
            .disabled(!isEnabled)
    }
    
    @ViewBuilder private func settings() -> some View {
        VSegmentedPicker(
            selection: .init(
                get: { VMenuPickerState(isEnabled: isEnabled) },
                set: { isEnabled = $0 == .enabled }
            ),
            headerTitle: "State"
        )

        VSegmentedPicker(
            selection: $labelType,
            headerTitle: "Content"
        )
    }
}

// MARK: - Helpers
private typealias VMenuPickerState = VSecondaryButtonState

private typealias VMenuPickerContent = VSegmentedPickerContent

private typealias VMenuPickerDataSource = VSegmentedPickerDataSource

// MARK: - Preview
struct VMenuPickerDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VMenuPickerDemoView()
    }
}
