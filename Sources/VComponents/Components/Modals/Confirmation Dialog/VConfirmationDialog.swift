//
//  VConfirmationDialog.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/1/21.
//

import SwiftUI

// MARK: - V Confirmation Dialog Sheet
/// Modal component that presents bottom sheet menu of actions.
///
/// Message can be passed as parameter.
///
/// `vConfirmationDialog` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
///
/// Usage example:
///
///     @State var isPresented: Bool = false
///
///     var body: some View {
///         VPlainButton(
///             action: { isPresented = true },
///             title: "Present"
///         )
///             .vConfirmationDialog(isPresented: $isPresented, confirmationDialog: {
///                 VConfirmationDialog(
///                     title: "Lorem ipsum dolor sit amet",
///                     message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
///                     actions: [
///                         .standard(action: {}, title: "Option A"),
///                         .standard(action: {}, title: "Option B"),
///                         .destructive(action: {}, title: "Delete"),
///                         .cancel(title: "Cancel")
///                     ]
///                 )
///             })
///
public struct VConfirmationDialog {
    // MARK: Properties
    fileprivate let title: String?
    fileprivate let message: String?
    fileprivate let actions: [VConfirmationDialogButton]
    
    // MARK: Initializrs
    /// Initializes component with title, message, and rows.
    public init(
        title: String?,
        message: String?,
        actions: [VConfirmationDialogButton]
    ) {
        self.title = title
        self.message = message
        self.actions = actions
    }
}

// MARK: - Extension
extension View {
    /// Presents `VConfirmationDialog` when boolean is `true`.
    public func vConfirmationDialog(
        isPresented: Binding<Bool>,
        confirmationDialog: @escaping () -> VConfirmationDialog
    ) -> some View {
        let confirmationDialog = confirmationDialog()
        let actions: [VConfirmationDialogButton] = VConfirmationDialogButton.process(confirmationDialog.actions)

        return self
            .confirmationDialog(
                confirmationDialog.title ?? "",
                isPresented: isPresented,
                titleVisibility: {
                    switch (confirmationDialog.title, confirmationDialog.message) {
                    case (nil, nil): return .hidden
                    case (nil, _?): return .visible
                    case (_?, nil): return .visible
                    case (_?, _?): return .visible
                    }
                }(),
                actions: {
                    ForEach(actions.indices, id: \.self, content: { i in
                        actions[i].swiftUIButton
                    })
                },
                message: {
                    if let message = confirmationDialog.message {
                        Text(message)
                    }
                }
            )
    }
}
