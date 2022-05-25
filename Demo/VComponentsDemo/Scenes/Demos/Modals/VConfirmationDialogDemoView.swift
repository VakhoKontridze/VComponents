//
//  VConfirmationDialogDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 2/1/21.
//

import SwiftUI
import VComponents

// MARK: - V Confirmation Dialog Demo View
struct VConfirmationDialogDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "Confirmation Dialog" }
    
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
            .vConfirmationDialog(
                isPresented: $isPresented,
                title: "Lorem Ipsum Dolor Sit Amet",
                message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
                actions: [
                    .standard(action: {}, title: "Option A"),
                    .standard(action: {}, title: "Option B"),
                    .destructive(action: {}, title: "Delete"),
                    .cancel(title: "Cancel")
                ]
            )
    }
}

// MARK: - Preview
struct VConfirmationDialogDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VConfirmationDialogDemoView()
    }
}
