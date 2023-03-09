//
//  VConfirmationDialogContentView.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 16.07.22.
//

import SwiftUI

// MARK: - V Confirmation Dialog Content View
struct VConfirmationDialogContentView: View {
    // MARK: Properties
    let buttons: [any VConfirmationDialogButtonProtocol]
    
    // MARK: Initializers
    init(button: [any VConfirmationDialogButtonProtocol]) {
        self.buttons = VConfirmationDialogButtonBuilder.process(button)
    }
    
    // MARK: Body
    var body: some View {
        ForEach(buttons.indices, id: \.self, content: { i in
            buttons[i].makeBody()
        })
    }
}

// MARK: - Preview
struct VConfirmationDialogContentView_Previews: PreviewProvider {
    static var previews: some View {
        ColorSchemePreview(title: nil, content: Preview.init)
    }
    
    private struct Preview: View {
        var body: some View {
            PreviewContainer(content: {
                VPlainButton(
                    action: {},
                    title: "Present"
                )
                    .vConfirmationDialog(
                        isPresented: .constant(true),
                        title: "Lorem Ipsum Dolor Sit Amet",
                        message: "Lorem ipsum dolor sit amet",
                        actions: {
                            VConfirmationDialogButton(action: { print("Confirmed A") }, title: "Option A")
                            VConfirmationDialogButton(action: { print("Confirmed B") }, title: "Option B")
                            VConfirmationDialogDestructiveButton(action: { print("Deleted") }, title: "Delete")
                            VConfirmationDialogCancelButton(action: nil)
                        }
                    )
            })
        }
    }
}
