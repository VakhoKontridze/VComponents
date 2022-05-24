//
//  VStepperDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VComponents

// MARK: - V Stepper Demo View
struct VStepperDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "Stepper" }
    
    @State private var isEnabled: Bool = true
    @State private var value: Int = 5

    // MARK: Body
    var body: some View {
        DemoView(component: component, settingsSections: settings)
            .standardNavigationTitle(Self.navBarTitle)
    }
    
    private func component() -> some View {
        VSliderDemoView.sliderRowView(title: .init(value), content: {
            VStepper(
                range: 1...25,
                value: $value
            )
                .disabled(!isEnabled)
        })
    }
    
    @ViewBuilder private func settings() -> some View {
        VSegmentedPicker(
            selection: .init(
                get: { VStepperState(isEnabled: isEnabled) },
                set: { isEnabled = $0 == .enabled }
            ),
            headerTitle: "State"
        )
    }
}

// MARK: - Helpers
private typealias VStepperState = VSecondaryButtonInternalState

// MARK: - Preview
struct VStepperDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VStepperDemoView()
    }
}
