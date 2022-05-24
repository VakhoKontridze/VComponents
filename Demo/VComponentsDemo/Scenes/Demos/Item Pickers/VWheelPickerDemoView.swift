//
//  VWheelPickerDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 1/8/21.
//

import SwiftUI
import VComponents

// MARK: - V Wheel Picker Demo View
struct VWheelPickerDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "Wheel Picker" }
    
    @State private var selection: VWheelPickerDataSource = .green
    @State private var isEnabled: Bool = true
    @State private var contentType: VWheelPickerContent = .title
    @State private var hasHeader: Bool = true
    @State private var hasFooter: Bool = true

    // MARK: Body
    var body: some View {
        DemoView(component: component, settingsSections: settings)
            .standardNavigationTitle(Self.navBarTitle)
    }
    
    private func component() -> some View {
        Group(content: {
            switch contentType {
            case .title:
                VWheelPicker(
                    selection: $selection,
                    headerTitle: hasHeader ? "Lorem ipsum dolor sit amet" : nil,
                    footerTitle: hasFooter ? "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam tincidunt ante at finibus cursus." : nil
                )

            case .custom:
                VWheelPicker(
                    selection: $selection,
                    headerTitle: hasHeader ? "Lorem ipsum dolor sit amet" : nil,
                    footerTitle: hasFooter ? "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam tincidunt ante at finibus cursus." : nil,
                    content: { $0.pickerSymbol }
                )
            }
        })
            .disabled(!isEnabled)
    }
    
    @DemoViewSettingsSectionBuilder private func settings() -> some View {
        DemoViewSettingsSection(content: {
            VSegmentedPicker(
                selection: .init(
                    get: { VWheelPickerState(isEnabled: isEnabled) },
                    set: { isEnabled = $0 == .enabled }
                ),
                headerTitle: "State"
            )
        })

        DemoViewSettingsSection(content: {
            VSegmentedPicker(selection: $contentType, headerTitle: "Content")
        })

        DemoViewSettingsSection(content: {
            ToggleSettingView(isOn: $hasHeader, title: "Header")

            ToggleSettingView(isOn: $hasFooter, title: "Footer")
        })
    }
}

// MARK: - Helpers
private typealias VWheelPickerState = VSecondaryButtonState

private typealias VWheelPickerContent = VSegmentedPickerContent

private typealias VWheelPickerDataSource = VSegmentedPickerDataSource

// MARK: - Preview
struct VWheelPickerDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VWheelPickerDemoView()
    }
}
