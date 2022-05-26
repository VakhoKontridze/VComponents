//
//  VLinkDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 2/7/21.
//

import SwiftUI
import VComponents

// MARK: - V Link Demo View
struct VLinkDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "Link" }
    
    @State private var isEnabled: Bool = true

    // MARK: Body
    var body: some View {
        DemoView(component: component, settings: settings)
            .standardNavigationTitle(Self.navBarTitle)
    }
    
    @ViewBuilder private func component() -> some View {
        VLink(url: url, label: {
            VSecondaryButton(
                action: {},
                title: buttonTitle
            )
        })
            .disabled(!isEnabled)
    }
    
    @ViewBuilder private func settings() -> some View {
        VSegmentedPicker(
            selection: .init(
                get: { VLinkState(isEnabled: isEnabled) },
                set: { isEnabled = $0 == .enabled }
            ),
            headerTitle: "State"
        )
    }
    
    private var buttonTitle: String { "Lorem Ipsum" }
    
    private var url: URL { .init(string: "https://www.apple.com")! } // fatalError
}

// MARK: - Helpers
private typealias VLinkState = VSecondaryButtonInternalState

// MARK: - Preview
struct VLinkDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VLinkDemoView()
    }
}
