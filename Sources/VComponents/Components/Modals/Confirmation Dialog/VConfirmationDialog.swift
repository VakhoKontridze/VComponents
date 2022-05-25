//
//  Vswift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/1/21.
//

import SwiftUI

// MARK: - Bool
extension View {
    /// Presents `VConfirmationDialog` when boolean is `true`.
    ///
    /// Modal component that presents bottom sheet menu of actions.
    ///
    /// Confirmation dialog can have one, two, or many buttons. Two buttons are stacked horizontally, while more are stacked vertically.
    ///
    /// `vConfirmationDialog` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
    ///
    /// Usage Example:
    ///
    ///     @State var isPresented: Bool = false
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { isPresented = true },
    ///             title: "Present"
    ///         )
    ///             .vConfirmationDialog(
    ///                 isPresented: $isPresented,
    ///                 title: "Lorem Ipsum Dolor Sit Amet",
    ///                 message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
    ///                 actions: [
    ///                     .standard(action: {}, title: "Option A"),
    ///                     .standard(action: {}, title: "Option B"),
    ///                     .destructive(action: {}, title: "Delete"),
    ///                     .cancel(title: "Cancel")
    ///                 ]
    ///             )
    ///     }
    ///
    public func vConfirmationDialog(
        isPresented: Binding<Bool>,
        title: String?,
        message: String?,
        actions: [VConfirmationDialogButton]
    ) -> some View {
        let actions: [VConfirmationDialogButton] = VConfirmationDialogButton.process(actions)
        
        return self
            .confirmationDialog(
                title ?? "",
                isPresented: isPresented,
                titleVisibility: .vConfirmationDialog(title: title, message: message),
                actions: {
                    ForEach(actions.indices, id: \.self, content: { i in
                        actions[i].swiftUIButton
                    })
                },
                message: {
                    if let message = message {
                        Text(message)
                    }
                }
            )
    }
}

// MARK: - Item
extension View {
    /// Presents `VConfirmationDialog` using the item as data source for content.
    ///
    /// Modal component that presents bottom sheet menu of actions.
    ///
    /// Confirmation dialog can have one, two, or many buttons. Two buttons are stacked horizontally, while more are stacked vertically.
    ///
    /// `vConfirmationDialog` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
    ///
    /// Usage Example:
    ///
    ///     struct ConfirmationDialogItem: Identifiable {
    ///         let id: UUID = .init()
    ///     }
    ///
    ///     @State var confirmationDialogItem: ConfirmationDialogItem?
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { confirmationDialogItem = .init() },
    ///             title: "Present"
    ///         )
    ///             .vConfirmationDialog(
    ///                 item: $confirmationDialogItem,
    ///                 title: "Lorem Ipsum Dolor Sit Amet",
    ///                 message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
    ///                 actions: [
    ///                     .standard(action: {}, title: "Option A"),
    ///                     .standard(action: {}, title: "Option B"),
    ///                     .destructive(action: {}, title: "Delete"),
    ///                     .cancel(title: "Cancel")
    ///                 ]
    ///             )
    ///     }
    ///
    public func vConfirmationDialog<Item>(
        item: Binding<Item?>,
        title: String?,
        message: String?,
        actions: [VConfirmationDialogButton]
    ) -> some View
        where Item: Identifiable
    {
        let actions: [VConfirmationDialogButton] = VConfirmationDialogButton.process(actions)
        
        return self
            .confirmationDialog(
                title ?? "",
                isPresented: .init(
                    get: { item.wrappedValue != nil },
                    set: { if !$0 { item.wrappedValue = nil } }
                ),
                titleVisibility: .vConfirmationDialog(title: title, message: message),
                actions: {
                    ForEach(actions.indices, id: \.self, content: { i in
                        actions[i].swiftUIButton
                    })
                },
                message: {
                    if let message = message {
                        Text(message)
                    }
                }
            )
    }
}

// MARK: - Presenting Data
extension View {
    /// Presents `VConfirmationDialog` when boolean is `true` using data to produce content.
    ///
    /// Modal component that presents bottom sheet menu of actions.
    ///
    /// Confirmation dialog can have one, two, or many buttons. Two buttons are stacked horizontally, while more are stacked vertically.
    ///
    /// `vConfirmationDialog` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
    ///
    /// For the dialog to appear, both `isPresented` must be true and `data` must not be nil.
    /// The `data` should not change after the presentation occurs.
    /// Any changes that you make after the presentation occurs are ignored.
    ///
    /// Usage Example:
    ///
    ///     struct ConfirmationDialogData {}
    ///
    ///     @State var isPresented: Bool = false
    ///
    ///     @State var confirmationDialogData: ConfirmationDialogData?
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { isPresented = true; confirmationDialogData = .init() },
    ///             title: "Present"
    ///         )
    ///             .vConfirmationDialog(
    ///                 isPresented: $isPresented,
    ///                 presenting: confirmationDialogData,
    ///                 title: "Lorem Ipsum Dolor Sit Amet",
    ///                 message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
    ///                 actions: [
    ///                     .standard(action: {}, title: "Option A"),
    ///                     .standard(action: {}, title: "Option B"),
    ///                     .destructive(action: {}, title: "Delete"),
    ///                     .cancel(title: "Cancel")
    ///                 ]
    ///             )
    ///     }
    ///
    public func vConfirmationDialog<T>(
        isPresented: Binding<Bool>,
        presenting data: T?,
        title: String?,
        message: String?,
        actions: [VConfirmationDialogButton]
    ) -> some View {
        let actions: [VConfirmationDialogButton] = VConfirmationDialogButton.process(actions)
        
        return self
            .confirmationDialog(
                title ?? "",
                isPresented: .init(
                    get: { isPresented.wrappedValue && data != nil },
                    set: { if !$0 { isPresented.wrappedValue = false } }
                ),
                titleVisibility: .vConfirmationDialog(title: title, message: message),
                actions: {
                    ForEach(actions.indices, id: \.self, content: { i in
                        actions[i].swiftUIButton
                    })
                },
                message: {
                    if let message = message {
                        Text(message)
                    }
                }
            )
    }
}

// MARK: - Helpers
extension Visibility {
    fileprivate static func vConfirmationDialog(title: String?, message: String?) -> Self {
        switch (title, message) {
        case (nil, nil): return .hidden
        case (nil, _?): return .visible
        case (_?, nil): return .visible
        case (_?, _?): return .visible
        }
    }
}
