//
//  VConfirmationDialogExtension.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/1/21.
//

import SwiftUI

// MARK: - Bool
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {
    /// Presents confirmation dialog when boolean is `true`.
    ///
    /// Modal component that presents bottom sheet menu of actions.
    ///
    /// Confirmation dialog can have one, two, or many buttons. Two buttons are stacked horizontally, while more are stacked vertically.
    ///
    /// `vConfirmationDialog` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
    ///
    ///     @State private var isPresented: Bool = false
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { isPresented = true },
    ///             title: "Present"
    ///         )
    ///             .vConfirmationDialog(
    ///                 isPresented: $isPresented,
    ///                 title: "Lorem Ipsum Dolor Sit Amet",
    ///                 message: "Lorem ipsum dolor sit amet",
    ///                 actions: {
    ///                     VConfirmationDialogButton(action: { print("Confirmed A") }, title: "Option A")
    ///                     VConfirmationDialogButton(action: { print("Confirmed B") }, title: "Option B")
    ///                     VConfirmationDialogDestructiveButton(action: { print("Deleted") }, title: "Delete")
    ///                     VConfirmationDialogCancelButton(action: nil)
    ///                 }
    ///             )
    ///     }
    ///
    public func vConfirmationDialog(
        isPresented: Binding<Bool>,
        title: String?,
        message: String?,
        @VConfirmationDialogButtonBuilder actions buttons: @escaping () -> [any VConfirmationDialogButtonProtocol]
    ) -> some View {
        self
            .confirmationDialog(
                title ?? "",
                isPresented: isPresented,
                titleVisibility: .vConfirmationDialog(title: title, message: message),
                actions: { VConfirmationDialogContentView(button: buttons()) },
                message: {
                    if let message {
                        Text(message)
                    }
                }
            )
    }
}

// MARK: - Item
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {
    /// Presents confirmation dialog using the item as data source for content.
    ///
    /// Modal component that presents bottom sheet menu of actions.
    ///
    /// Confirmation dialog can have one, two, or many buttons. Two buttons are stacked horizontally, while more are stacked vertically.
    ///
    /// `vConfirmationDialog` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
    ///
    ///     struct ConfirmationDialogItem: Identifiable {
    ///         let id: UUID = .init()
    ///     }
    ///
    ///     @State private var confirmationDialogItem: ConfirmationDialogItem?
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { confirmationDialogItem = ConfirmationDialogItem() },
    ///             title: "Present"
    ///         )
    ///             .vConfirmationDialog(
    ///                 item: $confirmationDialogItem,
    ///                 title: { item in "Lorem Ipsum" },
    ///                 message: { item in "Lorem ipsum dolor sit amet" },
    ///                 actions: { item in
    ///                     VConfirmationDialogButton(action: { print("Confirmed A") }, title: "Option A")
    ///                     VConfirmationDialogButton(action: { print("Confirmed B") }, title: "Option B")
    ///                     VConfirmationDialogDestructiveButton(action: { print("Deleted") }, title: "Delete")
    ///                     VConfirmationDialogCancelButton(action: nil)
    ///                 }
    ///             )
    ///     }
    ///
    public func vConfirmationDialog<Item>(
        item: Binding<Item?>,
        title: @escaping (Item) -> String?,
        message: @escaping (Item) -> String?,
        @VConfirmationDialogButtonBuilder actions buttons: @escaping (Item) -> [any VConfirmationDialogButtonProtocol]
    ) -> some View
        where Item: Identifiable
    {
        self
            .confirmationDialog(
                item.wrappedValue.flatMap { title($0) } ?? "",
                isPresented: Binding(
                    get: { item.wrappedValue != nil },
                    set: { if !$0 { item.wrappedValue = nil } }
                ),
                titleVisibility: .vConfirmationDialog(
                    title: item.wrappedValue.flatMap { title($0) },
                    message: item.wrappedValue.flatMap { message($0) }
                ),
                actions: {
                    if let item = item.wrappedValue {
                        VConfirmationDialogContentView(button: buttons(item))
                    }
                },
                message: {
                    if let item = item.wrappedValue, let message = message(item) {
                        Text(message)
                    }
                }
            )
    }
}

// MARK: - Presenting Data
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension View {
    /// Presents confirmation dialog when boolean is `true` using data to produce content.
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
    ///     struct ConfirmationDialogData {}
    ///
    ///     @State private var isPresented: Bool = false
    ///     @State private var confirmationDialogData: ConfirmationDialogData?
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: {
    ///                 isPresented = true
    ///                 confirmationDialogData = ConfirmationDialogData()
    ///             },
    ///             title: "Present"
    ///         )
    ///             .vConfirmationDialog(
    ///                 isPresented: $isPresented,
    ///                 presenting: confirmationDialogData,
    ///                 title: { data in "Lorem Ipsum" },
    ///                 message: { data in "Lorem ipsum dolor sit amet" },
    ///                 actions: { data in
    ///                     VConfirmationDialogButton(action: { print("Confirmed A") }, title: "Option A")
    ///                     VConfirmationDialogButton(action: { print("Confirmed B") }, title: "Option B")
    ///                     VConfirmationDialogDestructiveButton(action: { print("Deleted") }, title: "Delete")
    ///                     VConfirmationDialogCancelButton(action: nil)
    ///                 }
    ///             )
    ///     }
    ///
    public func vConfirmationDialog<T>(
        isPresented: Binding<Bool>,
        presenting data: T?,
        title: @escaping (T) -> String?,
        message: @escaping (T) -> String?,
        @VConfirmationDialogButtonBuilder actions buttons: @escaping (T) -> [any VConfirmationDialogButtonProtocol]
    ) -> some View {
        self
            .confirmationDialog(
                data.flatMap { title($0) } ?? "",
                isPresented: Binding(
                    get: { isPresented.wrappedValue && data != nil },
                    set: { if !$0 { isPresented.wrappedValue = false } }
                ),
                titleVisibility: .vConfirmationDialog(
                    title: data.flatMap { title($0) },
                    message: data.flatMap { message($0) }
                ),
                actions: {
                    if let data {
                        VConfirmationDialogContentView(button: buttons(data))
                    }
                },
                message: {
                    if let data, let message = message(data) {
                        Text(message)
                    }
                }
            )
    }
}

// MARK: - Helpers
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
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
