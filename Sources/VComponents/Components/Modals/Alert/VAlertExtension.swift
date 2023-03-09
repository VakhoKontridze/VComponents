//
//  VAlertExtension.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI
import VCore

// MARK: - Bool
@available(iOS 14.0, *)
extension View {
    /// Presents alert when `Bool` is `true`.
    ///
    /// Modal component that presents alert, and hosts content.
    ///
    /// UI Model, and present and dismiss handlers can be passed as parameters.
    ///
    /// Alert can have one, two, or many buttons. Two buttons are stacked horizontally, while more are stacked vertically.
    ///
    /// `vAlert` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
    ///
    ///     @State private var isPresented: Bool = false
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { isPresented = true },
    ///             title: "Present"
    ///         )
    ///             .vAlert(
    ///                 id: "some_alert",
    ///                 isPresented: $isPresented,
    ///                 title: "Lorem Ipsum",
    ///                 message: "Lorem ipsum dolor sit amet",
    ///                 actions: {
    ///                     VAlertPrimaryButton(action: { print("Confirmed") }, title: "Confirm")
    ///                     VAlertCancelButton(action: { print("Cancelled") })
    ///                 }
    ///             )
    ///     }
    ///
    public func vAlert(
        id: String,
        uiModel: VAlertUIModel = .init(),
        isPresented: Binding<Bool>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        title: String?,
        message: String?,
        @VAlertButtonBuilder actions buttons: @escaping () -> [any VAlertButtonProtocol]
    ) -> some View {
        self
            .presentationHost(
                id: id,
                isPresented: isPresented,
                content: {
                    VAlert<Never>(
                        uiModel: uiModel,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        title: title,
                        message: message,
                        content: .empty,
                        buttons: buttons()
                    )
                }
            )
    }
    
    /// Presents alert when `Bool` is `true`.
    ///
    /// Modal component that presents alert, and hosts content.
    ///
    /// UI Model, and present and dismiss handlers can be passed as parameters.
    ///
    /// Alert can have one, two, or many buttons. Two buttons are stacked horizontally, while more are stacked vertically.
    ///
    /// `vAlert` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
    ///
    ///     @State private var isPresented: Bool = false
    ///
    ///     @State private var text: String = ""
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { isPresented = true },
    ///             title: "Present"
    ///         )
    ///             .vAlert(
    ///                 id: "some_alert",
    ///                 isPresented: $isPresented,
    ///                 title: "Lorem Ipsum",
    ///                 message: "Lorem ipsum dolor sit amet",
    ///                 content: { VTextField(text: $text) },
    ///                 actions: {
    ///                     VAlertPrimaryButton(action: { print("Confirmed") }, title: "Confirm")
    ///                         .disabled(text.isEmpty)
    ///
    ///                     VAlertCancelButton(action: { print("Cancelled") })
    ///                 }
    ///             )
    ///     }
    ///
    public func vAlert(
        id: String,
        uiModel: VAlertUIModel = .init(),
        isPresented: Binding<Bool>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        title: String?,
        message: String?,
        @ViewBuilder content: @escaping () -> some View,
        @VAlertButtonBuilder actions buttons: @escaping () -> [any VAlertButtonProtocol]
    ) -> some View {
        self
            .presentationHost(
                id: id,
                isPresented: isPresented,
                content: {
                    VAlert(
                        uiModel: uiModel,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        title: title,
                        message: message,
                        content: .custom(content: content),
                        buttons: buttons()
                    )
                }
            )
    }
}

// MARK: - Item
@available(iOS 14.0, *)
extension View {
    /// Presents alert using the item as data source for content.
    ///
    /// Modal component that presents alert, and hosts content.
    ///
    /// UI Model, and present and dismiss handlers can be passed as parameters.
    ///
    /// Alert can have one, two, or many buttons. Two buttons are stacked horizontally, while more are stacked vertically.
    ///
    /// `vAlert` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
    ///
    ///     struct AlertItem: Identifiable {
    ///         let id: UUID = .init()
    ///     }
    ///
    ///     @State private var alertItem: AlertItem?
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { alertItem = .init() },
    ///             title: "Present"
    ///         )
    ///             .vAlert(
    ///                 id: "some_alert",
    ///                 item: $alertItem,
    ///                 title: { item in "Lorem Ipsum" },
    ///                 message: { item in "Lorem ipsum dolor sit amet" },
    ///                 actions: { item in
    ///                     VAlertPrimaryButton(action: { print("Confirmed") }, title: "Confirm")
    ///                     VAlertCancelButton(action: { print("Cancelled") })
    ///                 }
    ///             )
    ///     }
    ///
    public func vAlert<Item>(
        id: String,
        uiModel: VAlertUIModel = .init(),
        item: Binding<Item?>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        title: @escaping (Item) -> String?,
        message: @escaping (Item) -> String?,
        @VAlertButtonBuilder actions buttons: @escaping (Item) -> [any VAlertButtonProtocol]
    ) -> some View
        where Item: Identifiable
    {
        item.wrappedValue.map { PresentationHostDataSourceCache.shared.set(key: id, value: $0) }

        return self
            .presentationHost(
                id: id,
                item: item,
                content: {
                    VAlert<Never>(
                        uiModel: uiModel,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        title: {
                            if let item = item.wrappedValue ?? PresentationHostDataSourceCache.shared.get(key: id) as? Item {
                                return title(item)
                            } else {
                                return ""
                            }
                        }(),
                        message: {
                            if let item = item.wrappedValue ?? PresentationHostDataSourceCache.shared.get(key: id) as? Item {
                                return message(item)
                            } else {
                                return ""
                            }
                        }(),
                        content: .empty,
                        buttons: {
                            if let item = item.wrappedValue ?? PresentationHostDataSourceCache.shared.get(key: id) as? Item {
                                return buttons(item)
                            } else {
                                return []
                            }
                        }()
                    )
                }
            )
    }
    
    /// Presents alert using the item as data source for content.
    ///
    /// Modal component that presents alert, and hosts content.
    ///
    /// UI Model, and present and dismiss handlers can be passed as parameters.
    ///
    /// Alert can have one, two, or many buttons. Two buttons are stacked horizontally, while more are stacked vertically.
    ///
    /// `vAlert` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
    ///
    ///     struct AlertItem: Identifiable {
    ///         let id: UUID = .init()
    ///     }
    ///
    ///     @State private var alertItem: AlertItem?
    ///
    ///     @State private var text: String = ""
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { alertItem = .init() },
    ///             title: "Present"
    ///         )
    ///             .vAlert(
    ///                 id: "some_alert",
    ///                 item: $alertItem,
    ///                 title: { item in "Lorem Ipsum" },
    ///                 message: { item in "Lorem ipsum dolor sit amet" },
    ///                 content: { item in VTextField(text: $text) },
    ///                 actions: { item in
    ///                     VAlertPrimaryButton(action: { print("Confirmed") }, title: "Confirm")
    ///                         .disabled(text.isEmpty)
    ///
    ///                     VAlertCancelButton(action: { print("Cancelled") })
    ///                 }
    ///             )
    ///     }
    ///
    public func vAlert<Item>(
        id: String,
        uiModel: VAlertUIModel = .init(),
        item: Binding<Item?>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        title: @escaping (Item) -> String?,
        message: @escaping (Item) -> String?,
        @ViewBuilder content: @escaping (Item) -> some View,
        @VAlertButtonBuilder actions buttons: @escaping (Item) -> [any VAlertButtonProtocol]
    ) -> some View
        where Item: Identifiable
    {
        item.wrappedValue.map { PresentationHostDataSourceCache.shared.set(key: id, value: $0) }

        return self
            .presentationHost(
                id: id,
                item: item,
                content: {
                    VAlert(
                        uiModel: uiModel,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        title: {
                            if let item = item.wrappedValue ?? PresentationHostDataSourceCache.shared.get(key: id) as? Item {
                                return title(item)
                            } else {
                                return ""
                            }
                        }(),
                        message: {
                            if let item = item.wrappedValue ?? PresentationHostDataSourceCache.shared.get(key: id) as? Item {
                                return message(item)
                            } else {
                                return ""
                            }
                        }(),
                        content: {
                            if let item = item.wrappedValue ?? PresentationHostDataSourceCache.shared.get(key: id) as? Item {
                                return .custom(content: { content(item) })
                            } else {
                                return .empty
                            }
                        }(),
                        buttons: {
                            if let item = item.wrappedValue ?? PresentationHostDataSourceCache.shared.get(key: id) as? Item {
                                return buttons(item)
                            } else {
                                return []
                            }
                        }()
                    )
                }
            )
    }
}

// MARK: - Presenting Data
@available(iOS 14.0, *)
extension View {
    /// Presents alert when `Bool` is `true` using data to produce content.
    ///
    /// Modal component that presents alert, and hosts content.
    ///
    /// UI Model, and present and dismiss handlers can be passed as parameters.
    ///
    /// Alert can have one, two, or many buttons. Two buttons are stacked horizontally, while more are stacked vertically.
    ///
    /// `vAlert` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
    ///
    /// For the alert to appear, both `isPresented` must be true and `data` must not be nil.
    /// The `data` should not change after the presentation occurs.
    /// Any changes that you make after the presentation occurs are ignored.
    ///
    ///     struct AlertData {}
    ///
    ///     @State private var isPresented: Bool = false
    ///
    ///     @State private var alertData: AlertData?
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { isPresented = true; alertData = .init() },
    ///             title: "Present"
    ///         )
    ///             .vAlert(
    ///                 id: "some_alert",
    ///                 isPresented: $isPresented,
    ///                 presenting: $alertData,
    ///                 title: { data in "Lorem Ipsum" },
    ///                 message: { data in "Lorem ipsum dolor sit amet" },
    ///                 actions: { data in
    ///                     VAlertPrimaryButton(action: { print("Confirmed") }, title: "Confirm")
    ///                     VAlertCancelButton(action: { print("Cancelled") })
    ///                 }
    ///             )
    ///     }
    ///
    public func vAlert<T>(
        id: String,
        uiModel: VAlertUIModel = .init(),
        isPresented: Binding<Bool>,
        presenting data: T?,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        title: @escaping (T) -> String?,
        message: @escaping (T) -> String?,
        @VAlertButtonBuilder actions buttons: @escaping (T) -> [any VAlertButtonProtocol]
    ) -> some View {
        data.map { PresentationHostDataSourceCache.shared.set(key: id, value: $0) }

        return self
            .presentationHost(
                id: id,
                isPresented: isPresented,
                presenting: data,
                content: {
                    VAlert<Never>(
                        uiModel: uiModel,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        title: {
                            if let data = data ?? PresentationHostDataSourceCache.shared.get(key: id) as? T {
                                return title(data)
                            } else {
                                return ""
                            }
                        }(),
                        message: {
                            if let data = data ?? PresentationHostDataSourceCache.shared.get(key: id) as? T {
                                return message(data)
                            } else {
                                return ""
                            }
                        }(),
                        content: .empty,
                        buttons: {
                            if let data = data ?? PresentationHostDataSourceCache.shared.get(key: id) as? T {
                                return buttons(data)
                            } else {
                                return []
                            }
                        }()
                    )
                }
            )
    }
    
    /// Presents alert when `Bool` is `true` using data to produce content.
    ///
    /// Modal component that presents alert, and hosts content.
    ///
    /// UI Model, and present and dismiss handlers can be passed as parameters.
    ///
    /// Alert can have one, two, or many buttons. Two buttons are stacked horizontally, while more are stacked vertically.
    ///
    /// `vAlert` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
    ///
    /// For the alert to appear, both `isPresented` must be true and `data` must not be nil.
    /// The `data` should not change after the presentation occurs.
    /// Any changes that you make after the presentation occurs are ignored.
    ///
    ///     struct AlertData {}
    ///
    ///     @State private var isPresented: Bool = false
    ///     @State private var alertData: AlertData?
    ///
    ///     @State private var text: String = ""
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { isPresented = true; alertData = .init() },
    ///             title: "Present"
    ///         )
    ///             .vAlert(
    ///                 id: "some_alert",
    ///                 isPresented: $isPresented,
    ///                 presenting: $alertData,
    ///                 title: { data in "Lorem Ipsum" },
    ///                 message: { data in "Lorem ipsum dolor sit amet" },
    ///                 content: { data in VTextField(text: $text) },
    ///                 actions: { data in
    ///                     VAlertPrimaryButton(action: { print("Confirmed") }, title: "Confirm")
    ///                         .disabled(text.isEmpty)
    ///
    ///                     VAlertCancelButton(action: { print("Cancelled") })
    ///                 }
    ///             )
    ///     }
    ///
    public func vAlert<T>(
        id: String,
        uiModel: VAlertUIModel = .init(),
        isPresented: Binding<Bool>,
        presenting data: T?,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        title: @escaping (T) -> String?,
        message: @escaping (T) -> String?,
        @ViewBuilder content: @escaping (T) -> some View,
        @VAlertButtonBuilder actions buttons: @escaping (T) -> [any VAlertButtonProtocol]
    ) -> some View {
        data.map { PresentationHostDataSourceCache.shared.set(key: id, value: $0) }

        return self
            .presentationHost(
                id: id,
                isPresented: isPresented,
                presenting: data,
                content: {
                    VAlert(
                        uiModel: uiModel,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        title: {
                            if let data = data ?? PresentationHostDataSourceCache.shared.get(key: id) as? T {
                                return title(data)
                            } else {
                                return ""
                            }
                        }(),
                        message: {
                            if let data = data ?? PresentationHostDataSourceCache.shared.get(key: id) as? T {
                                return message(data)
                            } else {
                                return ""
                            }
                        }(),
                        content: {
                            if let data = data ?? PresentationHostDataSourceCache.shared.get(key: id) as? T {
                                return .custom(content: { content(data) })
                            } else {
                                return .empty
                            }
                        }(),
                        buttons: {
                            if let data = data ?? PresentationHostDataSourceCache.shared.get(key: id) as? T {
                                return buttons(data)
                            } else {
                                return []
                            }
                        }()
                    )
                }
            )
    }
}

// MARK: - Error
@available(iOS 14.0, *)
extension View {
    /// Presents alert when `Bool` is `true` using `Error`
    ///
    /// Modal component that presents alert, and hosts content.
    ///
    /// UI Model, and present and dismiss handlers can be passed as parameters.
    ///
    /// Alert can have one, two, or many buttons. Two buttons are stacked horizontally, while more are stacked vertically.
    ///
    /// `vAlert` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
    ///
    /// For the alert to appear, both `isPresented` must be true and `error` must not be nil.
    /// The `error` should not change after the presentation occurs.
    /// Any changes that you make after the presentation occurs are ignored.
    ///
    ///     @State private var isPresented: Bool = false
    ///
    ///     @State private var alertError: Error?
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { isPresented = true; alertError = SomeError() },
    ///             title: "Present"
    ///         )
    ///             .vAlert(
    ///                 id: "some_alert",
    ///                 isPresented: $isPresented,
    ///                 presenting: $alertError,
    ///                 title: { error in "Lorem Ipsum" },
    ///                 message: { error in "Lorem ipsum dolor sit amet" },
    ///                 actions: { error in }
    ///             )
    ///     }
    ///
    public func vAlert<E>(
        id: String,
        uiModel: VAlertUIModel = .init(),
        isPresented: Binding<Bool>,
        error: E?,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        title: @escaping (E) -> String?,
        message: @escaping (E) -> String?,
        @VAlertButtonBuilder actions buttons: @escaping (E) -> [any VAlertButtonProtocol]
    ) -> some View
        where E: Error
    {
        error.map { PresentationHostDataSourceCache.shared.set(key: id, value: $0) }

        return self
            .presentationHost(
                id: id,
                isPresented: isPresented,
                error: error,
                content: {
                    VAlert<Never>(
                        uiModel: uiModel,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        title: {
                            if let error = error ?? PresentationHostDataSourceCache.shared.get(key: id) as? E {
                                return title(error)
                            } else {
                                return ""
                            }
                        }(),
                        message: {
                            if let error = error ?? PresentationHostDataSourceCache.shared.get(key: id) as? E {
                                return message(error)
                            } else {
                                return ""
                            }
                        }(),
                        content: .empty,
                        buttons: {
                            if let error = error ?? PresentationHostDataSourceCache.shared.get(key: id) as? E {
                                return buttons(error)
                            } else {
                                return []
                            }
                        }()
                    )
                }
            )
    }
    
    /// Presents alert when `Bool` is `true` using `Error`
    ///
    /// Modal component that presents alert, and hosts content.
    ///
    /// UI Model, and present and dismiss handlers can be passed as parameters.
    ///
    /// Alert can have one, two, or many buttons. Two buttons are stacked horizontally, while more are stacked vertically.
    ///
    /// `vAlert` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
    ///
    /// For the alert to appear, both `isPresented` must be true and `error` must not be nil.
    /// The `error` should not change after the presentation occurs.
    /// Any changes that you make after the presentation occurs are ignored.
    ///
    ///     @State private var isPresented: Bool = false
    ///
    ///     @State private var alertError: Error?
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { isPresented = true; alertError = SomeError() },
    ///             title: "Present"
    ///         )
    ///             .vAlert(
    ///                 id: "some_alert",
    ///                 isPresented: $isPresented,
    ///                 presenting: $alertError,
    ///                 title: { error in "Lorem Ipsum" },
    ///                 message: { error in "Lorem ipsum dolor sit amet" },
    ///                 content: { error in Image("Error") },
    ///                 actions: { error in }
    ///             )
    ///     }
    ///
    public func vAlert<E>(
        id: String,
        uiModel: VAlertUIModel = .init(),
        isPresented: Binding<Bool>,
        error: E?,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        title: @escaping (E) -> String?,
        message: @escaping (E) -> String?,
        @ViewBuilder content: @escaping (E) -> some View,
        @VAlertButtonBuilder actions buttons: @escaping (E) -> [any VAlertButtonProtocol]
    ) -> some View
        where E: Error
    {
        error.map { PresentationHostDataSourceCache.shared.set(key: id, value: $0) }

        return self
            .presentationHost(
                id: id,
                isPresented: isPresented,
                error: error,
                content: {
                    VAlert(
                        uiModel: uiModel,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        title: {
                            if let error = error ?? PresentationHostDataSourceCache.shared.get(key: id) as? E {
                                return title(error)
                            } else {
                                return ""
                            }
                        }(),
                        message: {
                            if let error = error ?? PresentationHostDataSourceCache.shared.get(key: id) as? E {
                                return message(error)
                            } else {
                                return ""
                            }
                        }(),
                        content: {
                            if let error = error ?? PresentationHostDataSourceCache.shared.get(key: id) as? E {
                                return .custom(content: { content(error) })
                            } else {
                                return .empty
                            }
                        }(),
                        buttons: {
                            if let error = error ?? PresentationHostDataSourceCache.shared.get(key: id) as? E {
                                return buttons(error)
                            } else {
                                return []
                            }
                        }()
                    )
                }
            )
    }
}
