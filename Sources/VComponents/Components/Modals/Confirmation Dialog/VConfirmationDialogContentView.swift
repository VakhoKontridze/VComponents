//
//  VConfirmationDialogContentView.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 16.07.22.
//

import SwiftUI

// MARK: - V Confirmation Dialog Content View
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
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
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct VConfirmationDialogContentView_Previews: PreviewProvider {
    // Configuration
    private static var interfaceOrientation: InterfaceOrientation { .portrait }
    private static var languageDirection: LayoutDirection { .leftToRight }
    private static var colorScheme: ColorScheme { .light }

    // Previews
    static var previews: some View {
        Group(content: {
            Preview().previewDisplayName("*")
        })
            .previewInterfaceOrientation(interfaceOrientation)
            .environment(\.layoutDirection, languageDirection)
            .colorScheme(colorScheme)
    }
    
    // MARK: Data
    private static var title: String { "Lorem Ipsum Dolor Sit Amet" }
    private static var message: String { "Lorem ipsum dolor sit amet" }

    // Previews (Scenes)
    private struct Preview: View {
        var body: some View {
            PreviewContainer(content: {
                Text("Present")
                    .vConfirmationDialog(
                        isPresented: .constant(true),
                        title: title,
                        message: message,
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
