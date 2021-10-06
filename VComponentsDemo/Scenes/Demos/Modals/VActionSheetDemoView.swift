//
//  VActionSheetDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 2/1/21.
//

import SwiftUI
import VComponents

// MARK: - V Action Sheet Demo View
struct VActionSheetDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "Action Sheet" }
    
    @State private var isPresented: Bool = false

    // MARK: Body
    var body: some View {
        VBaseView(title: Self.navBarTitle, content: {
            DemoView(component: component)
        })
    }
    
    private func component() -> some View {
        VSecondaryButton(action: { isPresented = true }, title: "Present")
            .vActionSheet(isPresented: $isPresented, actionSheet: {
                VActionSheet(
                    title: "Lorem ipsum dolor sit amet",
                    description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
                    rows: [
                        .standard(action: {}, title: "One"),
                        .standard(action: {}, title: "Two"),
                        .destructive(action: {}, title: "Three"),
                        .cancel(title: "Cancel")
                    ]
                )
            })
    }
}

// MARK: - Preview
struct VActionSheetDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VActionSheetDemoView()
    }
}
