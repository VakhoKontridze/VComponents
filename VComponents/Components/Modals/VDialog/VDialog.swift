//
//  VDialog.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI

// MARK: - V Dialog
/// Modal component that presents dialog when condition is true
///
/// Model, title, description, and content can be passed as parameters
///
/// Dialog can have one, two, or many buttons. Two buttons are stacked horizontally, while many buttons are stacked vertically.
///
/// `vModal` modifier can be used on any view down the view hierarchy, as content overlay will always be centered on the screen
///
/// # Usage Example #
///
/// ```
/// @State var isPresented: Bool = false
///
/// var body: some View {
///     VSecondaryButton(
///         action: { isPresented = true },
///         title: "Present"
///     )
///         .vDialog(isPresented: $isPresented, dialog: {
///             VDialog(
///                 buttons: .two(
///                     primary: .init(
///                         model: .primary,
///                         title: "Confirm",
///                         action: { print("Confirmed") }
///                     ),
///                     secondary: .init(
///                         model: .secondary,
///                         title: "Cancel",
///                         action: { print("Cancelled") }
///                     )
///                 ),
///                 title: "Lorem ipsum dolor sit amet",
///                 description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
///         )
///     })
/// }
/// ```
///
public struct VDialog<Content> where Content: View {
    // MARK: Properties
    fileprivate let model: VDialogModel
    fileprivate let dialogButtons: VDialogButtons
    fileprivate let title: String?
    fileprivate let description: String?
    fileprivate let content: (() -> Content)?
    
    // MARK: Initializers
    /// Initializes component with buttons, title, description, and content
    public init(
        model: VDialogModel = .init(),
        buttons dialogButtons: VDialogButtons,
        title: String?,
        description: String?,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.model = model
        self.dialogButtons = dialogButtons
        self.title = title
        self.description = description
        self.content = content
    }
    
    /// Initializes component with buttons, title, and description
    public init(
        model: VDialogModel = .init(),
        buttons dialogButtons: VDialogButtons,
        title: String?,
        description: String?
    )
        where Content == Never
    {
        self.model = model
        self.dialogButtons = dialogButtons
        self.title = title
        self.description = description
        self.content = nil
    }
}

// MARK: - Extension
extension View {
    /// Presents `VDialog`
    public func vDialog<Content>(
        isPresented: Binding<Bool>,
        dialog: @escaping () -> VDialog<Content>
    ) -> some View
        where Content: View
    {
        let dialog = dialog()
        
        return self
            .overlay(Group(content: {
                if isPresented.wrappedValue {
                    WindowOverlayView(
                        isPresented: isPresented,
                        content:
                            _VDialog(
                                model: dialog.model,
                                isPresented: isPresented,
                                dialogButtons: dialog.dialogButtons,
                                title: dialog.title,
                                description: dialog.description,
                                content: dialog.content
                            )
                    )
                }
            }))
    }
}
