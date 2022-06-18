//
//  VAlertExtension.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI

// MARK: - Bool
extension View {
    /// Presents `VAlert` when `Bool` is `true`.
    ///
    /// Modal component that presents alert, and hosts content.
    ///
    /// UI Model, and present and dismiss handlers can be passed as parameters.
    ///
    /// Alert can have one, two, or many buttons. Two buttons are stacked horizontally, while more are stacked vertically.
    ///
    /// `vAlert` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
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
    ///                 title: "Lorem Ipsum",
    ///                 message: "Lorem ipsum dolor sit amet",
    ///                 actions: [
    ///                     .primary(action: { print("Confirmed") }, title: "Confirm"),
    ///                     .cancel(action: { print("Cancelled") })
    ///                 ]
    ///             )
    ///     }
    ///
    public func vAlert(
        uiModel: VAlertUIModel = .init(),
        isPresented: Binding<Bool>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        title: String?,
        message: String?,
        actions buttons: [VAlertButton]
    ) -> some View {
        self
            .onDisappear(perform: { PresentationHost.forceDismiss(in: self) })
            .background(PresentationHost(
                in: self,
                isPresented: isPresented,
                content: {
                    VAlert<Never>(
                        uiModel: uiModel,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        title: title,
                        message: message,
                        content: .empty,
                        buttons: buttons
                    )
                }
            ))
    }
    
    /// Presents `VAlert` when `Bool` is `true`.
    ///
    /// Modal component that presents alert, and hosts content.
    ///
    /// UI Model, and present and dismiss handlers can be passed as parameters.
    ///
    /// Alert can have one, two, or many buttons. Two buttons are stacked horizontally, while more are stacked vertically.
    ///
    /// `vAlert` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
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
    ///                 title: "Lorem Ipsum",
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
        uiModel: VAlertUIModel = .init(),
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
            .onDisappear(perform: { PresentationHost.forceDismiss(in: self) })
            .background(PresentationHost(
                in: self,
                isPresented: isPresented,
                content: {
                    VAlert(
                        uiModel: uiModel,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        title: title,
                        message: message,
                        content: .custom(content: content),
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
        uiModel: VAlertUIModel = .init(),
        item: Binding<Item?>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        title: @escaping (Item) -> String?,
        message: @escaping (Item) -> String?,
        actions buttons: @escaping (Item) -> [VAlertButton]
    ) -> some View
        where Item: Identifiable
    {
        item.wrappedValue.map { PresentationHostDataSourceCache.shared.set(key: self, value: $0) }

        return self
            .onDisappear(perform: { PresentationHost.forceDismiss(in: self) })
            .background(PresentationHost(
                in: self,
                isPresented: .init(
                    get: { item.wrappedValue != nil },
                    set: { if !$0 { item.wrappedValue = nil } }
                ),
                content: {
                    VAlert<Never>(
                        uiModel: uiModel,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        title: {
                            if let item = item.wrappedValue ?? PresentationHostDataSourceCache.shared.get(key: self) as? Item {
                                return title(item)
                            } else {
                                return ""
                            }
                        }(),
                        message: {
                            if let item = item.wrappedValue ?? PresentationHostDataSourceCache.shared.get(key: self) as? Item {
                                return message(item)
                            } else {
                                return ""
                            }
                        }(),
                        content: .empty,
                        buttons: {
                            if let item = item.wrappedValue ?? PresentationHostDataSourceCache.shared.get(key: self) as? Item {
                                return buttons(item)
                            } else {
                                return []
                            }
                        }()
                    )
                }
            ))
    }
    
    /// Presents `VAlert` using the item as data source for content.
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
        uiModel: VAlertUIModel = .init(),
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
        item.wrappedValue.map { PresentationHostDataSourceCache.shared.set(key: self, value: $0) }

        return self
            .onDisappear(perform: { PresentationHost.forceDismiss(in: self) })
            .background(PresentationHost(
                in: self,
                isPresented: .init(
                    get: { item.wrappedValue != nil },
                    set: { if !$0 { item.wrappedValue = nil } }
                ),
                content: {
                    VAlert<Content>(
                        uiModel: uiModel,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        title: {
                            if let item = item.wrappedValue ?? PresentationHostDataSourceCache.shared.get(key: self) as? Item {
                                return title(item)
                            } else {
                                return ""
                            }
                        }(),
                        message: {
                            if let item = item.wrappedValue ?? PresentationHostDataSourceCache.shared.get(key: self) as? Item {
                                return message(item)
                            } else {
                                return ""
                            }
                        }(),
                        content: {
                            if let item = item.wrappedValue ?? PresentationHostDataSourceCache.shared.get(key: self) as? Item {
                                return .custom(content: { content(item) })
                            } else {
                                return .empty
                            }
                        }(),
                        buttons: {
                            if let item = item.wrappedValue ?? PresentationHostDataSourceCache.shared.get(key: self) as? Item {
                                return buttons(item)
                            } else {
                                return []
                            }
                        }()
                    )
                }
            ))
    }
}

// MARK: - Presenting Data
extension View {
    /// Presents `VAlert` when `Bool` is `true` using data to produce content.
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
        uiModel: VAlertUIModel = .init(),
        isPresented: Binding<Bool>,
        presenting data: T?,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        title: @escaping (T) -> String?,
        message: @escaping (T) -> String?,
        actions buttons: @escaping (T) -> [VAlertButton]
    ) -> some View {
        data.map { PresentationHostDataSourceCache.shared.set(key: self, value: $0) }

        return self
            .onDisappear(perform: { PresentationHost.forceDismiss(in: self) })
            .background(PresentationHost(
                in: self,
                isPresented: .init(
                    get: { isPresented.wrappedValue && data != nil },
                    set: { if !$0 { isPresented.wrappedValue = false } }
                ),
                content: {
                    VAlert<Never>(
                        uiModel: uiModel,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        title: {
                            if let data = data ?? PresentationHostDataSourceCache.shared.get(key: self) as? T {
                                return title(data)
                            } else {
                                return ""
                            }
                        }(),
                        message: {
                            if let data = data ?? PresentationHostDataSourceCache.shared.get(key: self) as? T {
                                return message(data)
                            } else {
                                return ""
                            }
                        }(),
                        content: .empty,
                        buttons: {
                            if let data = data ?? PresentationHostDataSourceCache.shared.get(key: self) as? T {
                                return buttons(data)
                            } else {
                                return []
                            }
                        }()
                    )
                }
            ))
    }
    
    /// Presents `VAlert` when `Bool` is `true` using data to produce content.
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
        uiModel: VAlertUIModel = .init(),
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
        data.map { PresentationHostDataSourceCache.shared.set(key: self, value: $0) }

        return self
            .onDisappear(perform: { PresentationHost.forceDismiss(in: self) })
            .background(PresentationHost(
                in: self,
                isPresented: .init(
                    get: { isPresented.wrappedValue && data != nil },
                    set: { if !$0 { isPresented.wrappedValue = false } }
                ),
                content: {
                    VAlert<Content>(
                        uiModel: uiModel,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        title: {
                            if let data = data ?? PresentationHostDataSourceCache.shared.get(key: self) as? T {
                                return title(data)
                            } else {
                                return ""
                            }
                        }(),
                        message: {
                            if let data = data ?? PresentationHostDataSourceCache.shared.get(key: self) as? T {
                                return message(data)
                            } else {
                                return ""
                            }
                        }(),
                        content: {
                            if let data = data ?? PresentationHostDataSourceCache.shared.get(key: self) as? T {
                                return .custom(content: { content(data) })
                            } else {
                                return .empty
                            }
                        }(),
                        buttons: {
                            if let data = data ?? PresentationHostDataSourceCache.shared.get(key: self) as? T {
                                return buttons(data)
                            } else {
                                return []
                            }
                        }()
                    )
                }
            ))
    }
}

// MARK: - Error
extension View {
    /// Presents `VAlert` when `Bool` is `true` using `Error`
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
        uiModel: VAlertUIModel = .init(),
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
        error.map { PresentationHostDataSourceCache.shared.set(key: self, value: $0) }

        return self
            .onDisappear(perform: { PresentationHost.forceDismiss(in: self) })
            .background(PresentationHost(
                in: self,
                isPresented: .init(
                    get: { isPresented.wrappedValue && error != nil },
                    set: { if !$0 { isPresented.wrappedValue = false } }
                ),
                content: {
                    VAlert<Never>(
                        uiModel: uiModel,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        title: {
                            if let error = error ?? PresentationHostDataSourceCache.shared.get(key: self) as? E {
                                return title(error)
                            } else {
                                return ""
                            }
                        }(),
                        message: {
                            if let error = error ?? PresentationHostDataSourceCache.shared.get(key: self) as? E {
                                return message(error)
                            } else {
                                return ""
                            }
                        }(),
                        content: .empty,
                        buttons: {
                            if let error = error ?? PresentationHostDataSourceCache.shared.get(key: self) as? E {
                                return buttons(error)
                            } else {
                                return []
                            }
                        }()
                    )
                }
            ))
    }
    
    /// Presents `VAlert` when `Bool` is `true` using `Error`
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
        uiModel: VAlertUIModel = .init(),
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
        error.map { PresentationHostDataSourceCache.shared.set(key: self, value: $0) }

        return self
            .onDisappear(perform: { PresentationHost.forceDismiss(in: self) })
            .background(PresentationHost(
                in: self,
                isPresented: .init(
                    get: { isPresented.wrappedValue && error != nil },
                    set: { if !$0 { isPresented.wrappedValue = false } }
                ),
                content: {
                    VAlert<Content>(
                        uiModel: uiModel,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        title: {
                            if let error = error ?? PresentationHostDataSourceCache.shared.get(key: self) as? E {
                                return title(error)
                            } else {
                                return ""
                            }
                        }(),
                        message: {
                            if let error = error ?? PresentationHostDataSourceCache.shared.get(key: self) as? E {
                                return message(error)
                            } else {
                                return ""
                            }
                        }(),
                        content: {
                            if let error = error ?? PresentationHostDataSourceCache.shared.get(key: self) as? E {
                                return .custom(content: { content(error) })
                            } else {
                                return .empty
                            }
                        }(),
                        buttons: {
                            if let error = error ?? PresentationHostDataSourceCache.shared.get(key: self) as? E {
                                return buttons(error)
                            } else {
                                return []
                            }
                        }()
                    )
                }
            ))
    }
}
