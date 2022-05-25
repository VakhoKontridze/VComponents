//
//  VAlertExtension.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI

// MARK: - Bool
extension View {
    /// Presents `VAlert` when boolean is `true`.
    ///
    /// Modal component that presents alert, and hosts content.
    ///
    /// Model, and present and dismiss handlers can be passed as parameters.
    ///
    /// Alert can have one, two, or many buttons. Two buttons are stacked horizontally, while more are stacked vertically.
    ///
    /// `vAlert` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
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
    ///             .vAlert(
    ///                 isPresented: $isPresented,
    ///                 title: "Lorem ipsum",
    ///                 message: "Lorem ipsum dolor sit amet",
    ///                 actions: [
    ///                     .primary(action: { print("Confirmed") }, title: "Confirm"),
    ///                     .cancel(action: { print("Cancelled") })
    ///                 ]
    ///             )
    ///     }
    ///
    public func vAlert(
        model: VAlertModel = .init(),
        isPresented: Binding<Bool>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        title: String?,
        message: String?,
        actions buttons: [VAlertButton]
    ) -> some View {
        self
            .background(PresentationHost(
                isPresented: isPresented,
                content: {
                    VAlert<Never>(
                        model: model,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        title: title,
                        message: message,
                        content: nil,
                        buttons: buttons
                    )
                }
            ))
    }
    
    /// Presents `VAlert` when boolean is `true`.
    ///
    /// Modal component that presents alert, and hosts content.
    ///
    /// Model, and present and dismiss handlers can be passed as parameters.
    ///
    /// Alert can have one, two, or many buttons. Two buttons are stacked horizontally, while more are stacked vertically.
    ///
    /// `vAlert` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
    ///
    /// Usage Example:
    ///
    ///     @State var isPresented: Bool = false
    ///
    ///     @State var text: String = ""
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { isPresented = true },
    ///             title: "Present"
    ///         )
    ///             .vAlert(
    ///                 isPresented: $isPresented,
    ///                 title: "Lorem ipsum",
    ///                 message: "Lorem ipsum dolor sit amet",
    ///                 content: { VTextField(text: $text) },
    ///                 actions: [
    ///                     .primary(isEnabled: !text.isEmpty, action: { print("Confirmed") }, title: "Confirm"),
    ///                     .cancel(action: { print("Cancelled") })
    ///                 ]
    ///             )
    ///     }
    ///
    public func vAlert<Content>(
        model: VAlertModel = .init(),
        isPresented: Binding<Bool>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        title: String?,
        message: String?,
        @ViewBuilder content: @escaping () -> Content,
        actions buttons: [VAlertButton]
    ) -> some View
        where Content: View
    {
        self
            .background(PresentationHost(
                isPresented: isPresented,
                content: {
                    VAlert(
                        model: model,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        title: title,
                        message: message,
                        content: content,
                        buttons: buttons
                    )
                }
            ))
    }
}

// MARK: - Item
extension View {
    /// Presents `VAlert` using the item as data source for content.
    ///
    /// Modal component that presents alert, and hosts content.
    ///
    /// Model, and present and dismiss handlers can be passed as parameters.
    ///
    /// Alert can have one, two, or many buttons. Two buttons are stacked horizontally, while more are stacked vertically.
    ///
    /// `vAlert` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
    ///
    /// Usage Example:
    ///
    ///     struct AlertItem: Identifiable {
    ///         let id: UUID = .init()
    ///     }
    ///
    ///     @State var alertItem: AlertItem?
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { alertItem = .init() },
    ///             title: "Present"
    ///         )
    ///             .vAlert(
    ///                 item: $alertItem,
    ///                 title: { item in "Lorem Ipsum" },
    ///                 message: { item in "Lorem ipsum dolor sit amet" },
    ///                 actions: { item in
    ///                     [
    ///                         .primary(action: { print("Confirmed") }, title: "Confirm"),
    ///                         .cancel(action: { print("Cancelled") })
    ///                     ]
    ///                 }
    ///             )
    ///     }
    ///
    public func vAlert<Item>(
        model: VAlertModel = .init(),
        item: Binding<Item?>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        title: @escaping (Item) -> String?,
        message: @escaping (Item) -> String?,
        actions buttons: @escaping (Item) -> [VAlertButton]
    ) -> some View
        where Item: Identifiable
    {
        self
            .background(PresentationHost(
                isPresented: .init(
                    get: { item.wrappedValue != nil },
                    set: { if !$0 { item.wrappedValue = nil } }
                ),
                content: { () -> VAlert<Never> in 
                    let item = item.wrappedValue! // fatalError
                    
                    return .init(
                        model: model,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        title: title(item),
                        message: message(item),
                        content: nil,
                        buttons: buttons(item)
                    )
                }
            ))
    }
    
    /// Presents `VAlert` using the item as data source for content.
    ///
    /// Modal component that presents alert, and hosts content.
    ///
    /// Model, and present and dismiss handlers can be passed as parameters.
    ///
    /// Alert can have one, two, or many buttons. Two buttons are stacked horizontally, while more are stacked vertically.
    ///
    /// `vAlert` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
    ///
    /// Usage Example:
    ///
    ///     struct AlertItem: Identifiable {
    ///         let id: UUID = .init()
    ///     }
    ///
    ///     @State var alertItem: AlertItem?
    ///
    ///     @State var text: String = ""
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { alertItem = .init() },
    ///             title: "Present"
    ///         )
    ///             .vAlert(
    ///                 item: $alertItem,
    ///                 title: { item in "Lorem Ipsum" },
    ///                 message: { item in "Lorem ipsum dolor sit amet" },
    ///                 content: { item in VTextField(text: $text) },
    ///                 actions: { item in
    ///                     [
    ///                         .primary(isEnabled: !text.isEmpty, action: { print("Confirmed") }, title: "Confirm"),
    ///                         .cancel(action: { print("Cancelled") })
    ///                     ]
    ///                 }
    ///             )
    ///     }
    ///
    public func vAlert<Item, Content>(
        model: VAlertModel = .init(),
        item: Binding<Item?>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        title: @escaping (Item) -> String?,
        message: @escaping (Item) -> String?,
        @ViewBuilder content: @escaping (Item) -> Content,
        actions buttons: @escaping (Item) -> [VAlertButton]
    ) -> some View
        where
            Item: Identifiable,
            Content: View
    {
        self
            .background(PresentationHost(
                isPresented: .init(
                    get: { item.wrappedValue != nil },
                    set: { if !$0 { item.wrappedValue = nil } }
                ),
                content: { () -> VAlert<Content> in 
                    let item = item.wrappedValue! // fatalError
                    
                    return .init(
                        model: model,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        title: title(item),
                        message: message(item),
                        content: { content(item) },
                        buttons: buttons(item)
                    )
                }
            ))
    }
}

// MARK: - Presenting Data
extension View {
    /// Presents `VAlert` when boolean is `true` using data to produce content.
    ///
    /// Modal component that presents alert, and hosts content.
    ///
    /// Model, and present and dismiss handlers can be passed as parameters.
    ///
    /// Alert can have one, two, or many buttons. Two buttons are stacked horizontally, while more are stacked vertically.
    ///
    /// `vAlert` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
    ///
    /// For the alert to appear, both `isPresented` must be true and `data` must not be nil.
    /// The `data` should not change after the presentation occurs.
    /// Any changes that you make after the presentation occurs are ignored.
    ///
    /// Usage Example:
    ///
    ///     struct AlertData {}
    ///
    ///     @State var isPresented: Bool = false
    ///
    ///     @State var alertData: AlertData?
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { isPresented = true; alertData = .init() },
    ///             title: "Present"
    ///         )
    ///             .vAlert(
    ///                 isPresented: $isPresented,
    ///                 presenting: $alertData,
    ///                 title: { data in "Lorem Ipsum" },
    ///                 message: { data in "Lorem ipsum dolor sit amet" },
    ///                 actions: { data in
    ///                     [
    ///                         .primary(action: { print("Confirmed") }, title: "Confirm"),
    ///                         .cancel(action: { print("Cancelled") })
    ///                     ]
    ///                 }
    ///             )
    ///     }
    ///
    public func vAlert<T>(
        model: VAlertModel = .init(),
        isPresented: Binding<Bool>,
        presenting data: T?,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        title: @escaping (T) -> String?,
        message: @escaping (T) -> String?,
        actions buttons: @escaping (T) -> [VAlertButton]
    ) -> some View {
        self
            .background(PresentationHost(
                isPresented: .init(
                    get: { isPresented.wrappedValue && data != nil },
                    set: { if !$0 { isPresented.wrappedValue = false } }
                ),
                content: { () -> VAlert<Never> in
                    let data = data! // fatalError
                    
                    return .init(
                        model: model,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        title: title(data),
                        message: message(data),
                        content: nil,
                        buttons: buttons(data)
                    )
                }
            ))
    }
    
    /// Presents `VAlert` when boolean is `true` using data to produce content.
    ///
    /// Modal component that presents alert, and hosts content.
    ///
    /// Model, and present and dismiss handlers can be passed as parameters.
    ///
    /// Alert can have one, two, or many buttons. Two buttons are stacked horizontally, while more are stacked vertically.
    ///
    /// `vAlert` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
    ///
    /// For the alert to appear, both `isPresented` must be true and `data` must not be nil.
    /// The `data` should not change after the presentation occurs.
    /// Any changes that you make after the presentation occurs are ignored.
    ///
    /// Usage Example:
    ///
    ///     struct AlertData {}
    ///
    ///     @State var isPresented: Bool = false
    ///     @State var alertData: AlertData?
    ///
    ///     @State var text: String = ""
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { isPresented = true; alertData = .init() },
    ///             title: "Present"
    ///         )
    ///             .vAlert(
    ///                 isPresented: $isPresented,
    ///                 presenting: $alertData,
    ///                 title: { data in "Lorem Ipsum" },
    ///                 message: { data in "Lorem ipsum dolor sit amet" },
    ///                 content: { data in VTextField(text: $text) },
    ///                 actions: { data in
    ///                     [
    ///                         .primary(isEnabled: !text.isEmpty, action: { print("Confirmed") }, title: "Confirm"),
    ///                         .cancel(action: { print("Cancelled") })
    ///                     ]
    ///                 }
    ///             )
    ///     }
    ///
    public func vAlert<T, Content>(
        model: VAlertModel = .init(),
        isPresented: Binding<Bool>,
        presenting data: T?,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        title: @escaping (T) -> String?,
        message: @escaping (T) -> String?,
        @ViewBuilder content: @escaping (T) -> Content,
        actions buttons: @escaping (T) -> [VAlertButton]
    ) -> some View
        where Content: View
    {
        self
            .background(PresentationHost(
                isPresented: .init(
                    get: { isPresented.wrappedValue && data != nil },
                    set: { if !$0 { isPresented.wrappedValue = false } }
                ),
                content: { () -> VAlert<Content> in
                    let data = data! // fatalError
                    
                    return .init(
                        model: model,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        title: title(data),
                        message: message(data),
                        content: { content(data) },
                        buttons: buttons(data)
                    )
                }
            ))
    }
}

// MARK: - Error
extension View {
    /// Presents `VAlert` when boolean is `true` using `Error`
    ///
    /// Modal component that presents alert, and hosts content.
    ///
    /// Model, and present and dismiss handlers can be passed as parameters.
    ///
    /// Alert can have one, two, or many buttons. Two buttons are stacked horizontally, while more are stacked vertically.
    ///
    /// `vAlert` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
    ///
    /// For the alert to appear, both `isPresented` must be true and `error` must not be nil.
    /// The `error` should not change after the presentation occurs.
    /// Any changes that you make after the presentation occurs are ignored.
    ///
    /// Usage Example:
    ///
    ///     @State var isPresented: Bool = false
    ///
    ///     @State var alertError: Error?
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { isPresented = true; alertError = SomeError() },
    ///             title: "Present"
    ///         )
    ///             .vAlert(
    ///                 isPresented: $isPresented,
    ///                 presenting: $alertError,
    ///                 title: { error in "Lorem Ipsum" },
    ///                 message: { error in "Lorem ipsum dolor sit amet" },
    ///                 actions: { error in [] }
    ///             )
    ///     }
    ///
    public func vAlert<E>(
        model: VAlertModel = .init(),
        isPresented: Binding<Bool>,
        error: E?,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        title: @escaping (E) -> String?,
        message: @escaping (E) -> String?,
        actions buttons: @escaping (E) -> [VAlertButton]
    ) -> some View
        where E: Error
    {
        self
            .background(PresentationHost(
                isPresented: .init(
                    get: { isPresented.wrappedValue && error != nil },
                    set: { if !$0 { isPresented.wrappedValue = false } }
                ),
                content: { () -> VAlert<Never> in
                    let error = error! // fatalError
                    
                    return .init(
                        model: model,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        title: title(error),
                        message: message(error),
                        content: nil,
                        buttons: buttons(error)
                    )
                }
            ))
    }
    
    /// Presents `VAlert` when boolean is `true` using `Error`
    ///
    /// Modal component that presents alert, and hosts content.
    ///
    /// Model, and present and dismiss handlers can be passed as parameters.
    ///
    /// Alert can have one, two, or many buttons. Two buttons are stacked horizontally, while more are stacked vertically.
    ///
    /// `vAlert` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
    ///
    /// For the alert to appear, both `isPresented` must be true and `error` must not be nil.
    /// The `error` should not change after the presentation occurs.
    /// Any changes that you make after the presentation occurs are ignored.
    ///
    /// Usage Example:
    ///
    ///     @State var isPresented: Bool = false
    ///
    ///     @State var alertError: Error?
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { isPresented = true; alertError = SomeError() },
    ///             title: "Present"
    ///         )
    ///             .vAlert(
    ///                 isPresented: $isPresented,
    ///                 presenting: $alertError,
    ///                 title: { error in "Lorem Ipsum" },
    ///                 message: { error in "Lorem ipsum dolor sit amet" },
    ///                 content: { error in Image("Error") },
    ///                 actions: { error in [] }
    ///             )
    ///     }
    ///
    public func vAlert<E, Content>(
        model: VAlertModel = .init(),
        isPresented: Binding<Bool>,
        error: E?,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        title: @escaping (E) -> String?,
        message: @escaping (E) -> String?,
        @ViewBuilder content: @escaping (E) -> Content,
        actions buttons: @escaping (E) -> [VAlertButton]
    ) -> some View
        where
            E: Error,
            Content: View
    {
        self
            .background(PresentationHost(
                isPresented: .init(
                    get: { isPresented.wrappedValue && error != nil },
                    set: { if !$0 { isPresented.wrappedValue = false } }
                ),
                content: { () -> VAlert<Content> in
                    let error = error! // fatalError
                    
                    return .init(
                        model: model,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        title: title(error),
                        message: message(error),
                        content: { content(error) },
                        buttons: buttons(error)
                    )
                }
            ))
    }
}
