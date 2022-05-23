//
//  VDialog.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI

// MARK: - V Dialog
/// Modal component that presents dialog when condition is true.
///
/// Model, title, description, and content can be passed as parameters.
///
/// Dialog can have one, two, or many buttons. Two buttons are stacked horizontally, while many buttons are stacked vertically.
///
/// `vDialog` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
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
///             .vDialog(isPresented: $isPresented, dialog: {
///                 VDialog(
///                     title: "Lorem ipsum",
///                     description: "Lorem ipsum dolor sit amet",
///                     actions: [
///                         .primary(action: { print("Confirmed") }, title: "Confirm"),
///                         .cancel(action: { print("Cancelled") })
///                     ]
///                 )
///         })
///     }
///
public struct VDialog<Content>
    where Content: View
{
    // MARK: Properties
    fileprivate let model: VDialogModel
    
    fileprivate let title: String?
    fileprivate let description: String?
    fileprivate let content: (() -> Content)?
    fileprivate let buttons: [VDialogButton]
    
    // MARK: Initializers
    /// Initializes component with buttons, title, description, and content.
    public init(
        model: VDialogModel = .init(),
        title: String?,
        description: String?,
        @ViewBuilder content: @escaping () -> Content,
        actions buttons: [VDialogButton]
    ) {
        self.model = model
        self.title = title
        self.description = description
        self.content = content
        self.buttons = buttons
    }
    
    /// Initializes component with buttons, title, and description.
    public init(
        model: VDialogModel = .init(),
        title: String?,
        description: String?,
        actions buttons: [VDialogButton]
    )
        where Content == Never
    {
        self.model = model
        self.title = title
        self.description = description
        self.content = nil
        self.buttons = buttons
    }
}

// MARK: - Extension
extension View {
    /// Presents `VDialog` when boolean is true.
    public func vDialog<Content>(
        isPresented: Binding<Bool>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        dialog: @escaping () -> VDialog<Content>
    ) -> some View
        where Content: View
    {
        let dialog = dialog()
        
        return self
            .background(PresentationHost(
                isPresented: isPresented,
                content: {
                    _VDialog(
                        model: dialog.model,
                        presentHandler: presentHandler,
                        dismissHandler: dismissHandler,
                        title: dialog.title,
                        description: dialog.description,
                        content: dialog.content,
                        buttons: dialog.buttons
                    )
                }
            ))
    }
    
    /// Presents `VDialog` using the item as data source for content.
    @ViewBuilder public func vDialog<Item, Content>(
        item: Binding<Item?>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        dialog: @escaping (Item) -> VDialog<Content>
    ) -> some View
        where
            Item: Identifiable,
            Content: View
    {
        switch item.wrappedValue {
        case nil:
            self
            
        case let _item?:
            self
                .vDialog(
                    isPresented: .init(
                        get: { true },
                        set: { _ in item.wrappedValue = nil }
                    ),
                    onPresent: presentHandler,
                    onDismiss: dismissHandler,
                    dialog: { dialog(_item) }
                )
        }
    }
    
    /// Presents `VDialog` when boolean is true with an `Error`.
    public func vDialog<E, Content>(
        isPresented: Binding<Bool>,
        error: E?,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        dialog: @escaping (E?) -> VDialog<Content>
    ) -> some View
        where
            E: Error,
            Content: View
    {
        vDialog(
            isPresented: isPresented,
            onPresent: presentHandler,
            onDismiss: dismissHandler,
            dialog: { dialog(error) }
        )
    }
}
