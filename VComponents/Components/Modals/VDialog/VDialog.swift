//
//  VDialog.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI

// MARK:- V Dialog
/// Message component that presents dialog when condition is true
///
/// Model, title, description, onAppear and onDisappear callbacks, and content can be passed as parameters
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
///     .vDialog(isPresented: $isPresented, dialog: {
///         VDialog(
///             dialog: .two(
///                 primary: .init(
///                     model: .primary,
///                     title: "Confirm",
///                     action: { print("Confirmed") }
///                 ),
///                 secondary: .init(
///                     model: .secondary,
///                     title: "Cancel",
///                     action: { print("Cancelled") }
///                 )
///             ),
///             title: "Lorem ipsum dolor sit amet",
///             description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
///         )
///     })
/// }
/// ```
///
public struct VDialog<Content> where Content: View {
    // MARK: Properties
    public var model: VDialogModel = .init()
    public var dialogType: VDialogType
    public var title: String?
    public var description: String?
    public var content: (() -> Content)?
    public var appearAction: (() -> Void)?
    public var disappearAction: (() -> Void)?
    
    // MARK: Initializers
    public init(
        model: VDialogModel = .init(),
        dialog dialogType: VDialogType,
        title: String?,
        description: String?,
        @ViewBuilder content: @escaping () -> Content,
        onAppear appearAction: (() -> Void)? = nil,
        onDisappear disappearAction: (() -> Void)? = nil
    ) {
        self.model = model
        self.dialogType = dialogType
        self.title = title
        self.description = description
        self.content = content
        self.appearAction = appearAction
        self.disappearAction = disappearAction
    }
    
    public init(
        model: VDialogModel = .init(),
        dialog dialogType: VDialogType,
        title: String?,
        description: String?,
        onAppear appearAction: (() -> Void)? = nil,
        onDisappear disappearAction: (() -> Void)? = nil
    )
        where Content == Never
    {
        self.model = model
        self.dialogType = dialogType
        self.title = title
        self.description = description
        self.content = nil
        self.appearAction = appearAction
        self.disappearAction = disappearAction
    }
}

// MARK:- Extension
extension View {
    /// Presents dialog
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
                    UIKitRepresentable(
                        isPresented: isPresented,
                        content:
                            _VDialog(
                                model: dialog.model,
                                isPresented: isPresented,
                                dialog: dialog.dialogType,
                                title: dialog.title,
                                description: dialog.description,
                                content: dialog.content,
                                onAppear: dialog.appearAction,
                                onDisappear: dialog.disappearAction
                            )
                    )
                }
            }))
    }
}
