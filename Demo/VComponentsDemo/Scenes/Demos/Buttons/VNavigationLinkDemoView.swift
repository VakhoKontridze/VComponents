//
//  VNavigationLinkDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 18.12.20.
//

import SwiftUI
import VComponents

// MARK: - V Navigation Link Demo View
struct VNavigationLinkDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "Navigation Link" }
    
    @State private var isEnabled: Bool = true

    // MARK: Body
    var body: some View {
        DemoView(component: component, settings: settings)
            .standardNavigationTitle(Self.navBarTitle)
    }
    
    private func component() -> some View {
        VNavigationLink(
            destination: destination,
            title: buttonTitle
        )
            .disabled(!isEnabled)
    }
    
    private func settings() -> some View {
        VSegmentedPicker(
            selection: .init(
                get: { VNavigationLinkButtonInternalState(isEnabled: isEnabled) },
                set: { isEnabled = $0 == .enabled }
            ),
            headerTitle: "State"
        )
    }
    
    private var buttonTitle: String { "Lorem Ipsum" }
    
    private func destination() -> some View {
        ColorBook.canvas.ignoresSafeArea()
            .standardNavigationTitle("Destination")
    }
}

// MARK: - Helpers
private typealias VNavigationLinkButtonInternalState = VSecondaryButtonInternalState

// MARK: - Preview
struct VNavigationLinkDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VNavigationLinkDemoView()
    }
}
