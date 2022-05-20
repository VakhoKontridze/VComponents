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
        VNavigationLink(destination: destination, label: {
            VSecondaryButton(
                action: {},
                title: buttonTitle
            )
        })
            .disabled(!isEnabled)
    }
    
    private func settings() -> some View {
        VSegmentedPicker(
            selection: .init(
                get: { VNavigationLinkButtonState(isEnabled: isEnabled) },
                set: { isEnabled = $0 == .enabled }
            ),
            headerTitle: "State"
        )
    }
    
    private var buttonTitle: String { "Lorem Ipsum" }
    
    private func destination() -> some View {
        ColorBook.canvas.ignoresSafeArea(.all, edges: .all)
            .standardNavigationTitle("Destination")
    }
}

// MARK: - Helpers
private typealias VNavigationLinkButtonState = VSecondaryButtonState

// MARK: - Preview
struct VNavigationLinkDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VNavigationLinkDemoView()
    }
}
