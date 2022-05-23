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
        DemoView(component: component)
            .standardNavigationTitle(Self.navBarTitle)
    }
    
    private func component() -> some View {
        VPlainButton(
            action: { isPresented = true },
            title: "Present"
        )
            .vActionSheet(isPresented: $isPresented, actionSheet: {
                VActionSheet(
                    title: "Lorem ipsum dolor sit amet",
                    description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
                    actions: [
                        .standard(action: {}, title: "Option A"),
                        .standard(action: {}, title: "Option B"),
                        .destructive(action: {}, title: "Delete"),
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
