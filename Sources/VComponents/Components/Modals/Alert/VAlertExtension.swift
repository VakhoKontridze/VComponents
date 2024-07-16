//
//  VAlertExtension.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI
import VCore

// MARK: - Bool
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension View {
    /// Modal component that presents alert with actions and hosts content.
    ///
    /// Alert can have one, two, or many buttons.
    /// Two buttons are stacked horizontally, while more are stacked vertically.
    ///
    /// Optionally, content can be presented with methods that have `content` argument.
    ///
    ///     @State private var isPresented: Bool = false
    ///
    ///     var body: some View {
    ///         ZStack(content: {
    ///             VPlainButton(
    ///                 action: { isPresented = true },
    ///                 title: "Present"
    ///             )
    ///             .vAlert(
    ///                 id: "some_alert",
    ///                 isPresented: $isPresented,
    ///                 title: "Lorem Ipsum",
    ///                 message: "Lorem ipsum dolor sit amet",
    ///                 actions: {
    ///                     VAlertButton(role: .primary, action: { print("Confirmed") }, title: "Confirm")
    ///                     VAlertButton(role: .cancel, action: { print("Cancelled") }, title: "Cancel")
    ///                 }
    ///             )
    ///         })
    ///         .frame(maxWidth: .infinity, maxHeight: .infinity)
    ///         .presentationHostLayer() // Or declare in `App` on a `WindowScene`-level
    ///     }
    ///
    public func vAlert(
        layerID: String? = nil,
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
                layerID: layerID,
                id: id,
                uiModel: uiModel.presentationHostSubUIModel,
                isPresented: isPresented,
                onPresent: presentHandler,
                onDismiss: dismissHandler,
                content: {
                    VAlert<Never>(
                        uiModel: uiModel,
                        isPresented: isPresented,
                        title: title,
                        message: message,
                        content: .empty,
                        buttons: buttons()
                    )
                }
            )
    }
    
    /// Modal component that presents alert with actions and hosts content.
    ///
    /// For additional info, refer to method with `Bool` presentation flag.
    public func vAlert<Content>(
        layerID: String? = nil,
        id: String,
        uiModel: VAlertUIModel = .init(),
        isPresented: Binding<Bool>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        title: String?,
        message: String?,
        @ViewBuilder content: @escaping () -> Content,
        @VAlertButtonBuilder actions buttons: @escaping () -> [any VAlertButtonProtocol]
    ) -> some View
        where Content: View
    {
        self
            .presentationHost(
                layerID: layerID,
                id: id,
                uiModel: uiModel.presentationHostSubUIModel,
                isPresented: isPresented,
                onPresent: presentHandler,
                onDismiss: dismissHandler,
                content: {
                    VAlert<Content>(
                        uiModel: uiModel,
                        isPresented: isPresented,
                        title: title,
                        message: message,
                        content: .content(content: content),
                        buttons: buttons()
                    )
                }
            )
    }
}

// MARK: - Item
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension View {
    /// Modal component that presents alert with actions and hosts content.
    ///
    /// For additional info, refer to method with `Bool` presentation flag.
    public func vAlert<Item>(
        layerID: String? = nil,
        id: String,
        uiModel: VAlertUIModel = .init(),
        item: Binding<Item?>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        title: @escaping (Item) -> String?,
        message: @escaping (Item) -> String?,
        @VAlertButtonBuilder actions buttons: @escaping (Item) -> [any VAlertButtonProtocol]
    ) -> some View {
        item.wrappedValue.map { PresentationHostDataSourceCache.shared.set(key: id, value: $0) }

        let isPresented: Binding<Bool> = .init(
            get: { item.wrappedValue != nil },
            set: { if !$0 { item.wrappedValue = nil } }
        )

        return self
            .presentationHost(
                layerID: layerID,
                id: id,
                uiModel: uiModel.presentationHostSubUIModel,
                isPresented: isPresented,
                onPresent: presentHandler,
                onDismiss: dismissHandler,
                content: {
                    VAlert<Never>(
                        uiModel: uiModel,
                        isPresented: isPresented,
                        title: {
                            if let item = item.wrappedValue ?? PresentationHostDataSourceCache.shared.get(key: id) as? Item {
                                title(item)
                            } else {
                                ""
                            }
                        }(),
                        message: {
                            if let item = item.wrappedValue ?? PresentationHostDataSourceCache.shared.get(key: id) as? Item {
                                message(item)
                            } else {
                                ""
                            }
                        }(),
                        content: VAlertContent.empty,
                        buttons: {
                            if let item = item.wrappedValue ?? PresentationHostDataSourceCache.shared.get(key: id) as? Item {
                                buttons(item)
                            } else {
                                []
                            }
                        }()
                    )
                }
            )
    }
    
    /// Modal component that presents alert with actions and hosts content.
    ///
    /// For additional info, refer to method with `Bool` presentation flag.
    public func vAlert<Item, Content>(
        layerID: String? = nil,
        id: String,
        uiModel: VAlertUIModel = .init(),
        item: Binding<Item?>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        title: @escaping (Item) -> String?,
        message: @escaping (Item) -> String?,
        @ViewBuilder content: @escaping (Item) -> Content,
        @VAlertButtonBuilder actions buttons: @escaping (Item) -> [any VAlertButtonProtocol]
    ) -> some View
        where Content: View
    {
        item.wrappedValue.map { PresentationHostDataSourceCache.shared.set(key: id, value: $0) }

        let isPresented: Binding<Bool> = .init(
            get: { item.wrappedValue != nil },
            set: { if !$0 { item.wrappedValue = nil } }
        )

        return self
            .presentationHost(
                layerID: layerID,
                id: id,
                uiModel: uiModel.presentationHostSubUIModel,
                isPresented: isPresented,
                onPresent: presentHandler,
                onDismiss: dismissHandler,
                content: {
                    VAlert<Content>(
                        uiModel: uiModel,
                        isPresented: isPresented,
                        title: {
                            if let item = item.wrappedValue ?? PresentationHostDataSourceCache.shared.get(key: id) as? Item {
                                title(item)
                            } else {
                                ""
                            }
                        }(),
                        message: {
                            if let item = item.wrappedValue ?? PresentationHostDataSourceCache.shared.get(key: id) as? Item {
                                message(item)
                            } else {
                                ""
                            }
                        }(),
                        content: {
                            if let item = item.wrappedValue ?? PresentationHostDataSourceCache.shared.get(key: id) as? Item {
                                VAlertContent.content(content: { content(item) })
                            } else {
                                VAlertContent.empty
                            }
                        }(),
                        buttons: {
                            if let item = item.wrappedValue ?? PresentationHostDataSourceCache.shared.get(key: id) as? Item {
                                buttons(item)
                            } else {
                                []
                            }
                        }()
                    )
                }
            )
    }
}

// MARK: - Error
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension View {
    /// Modal component that presents alert with actions and hosts content.
    ///
    /// For additional info, refer to method with `Bool` presentation flag.
    public func vAlert<E>(
        layerID: String? = nil,
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

        let isPresented: Binding<Bool> = .init(
            get: { isPresented.wrappedValue && error != nil },
            set: { if !$0 { isPresented.wrappedValue = false } }
        )

        return self
            .presentationHost(
                layerID: layerID,
                id: id,
                uiModel: uiModel.presentationHostSubUIModel,
                isPresented: isPresented,
                onPresent: presentHandler,
                onDismiss: dismissHandler,
                content: {
                    VAlert<Never>(
                        uiModel: uiModel,
                        isPresented: isPresented,
                        title: {
                            if let error = error ?? PresentationHostDataSourceCache.shared.get(key: id) as? E {
                                title(error)
                            } else {
                                ""
                            }
                        }(),
                        message: {
                            if let error = error ?? PresentationHostDataSourceCache.shared.get(key: id) as? E {
                                message(error)
                            } else {
                                ""
                            }
                        }(),
                        content: VAlertContent.empty,
                        buttons: {
                            if let error = error ?? PresentationHostDataSourceCache.shared.get(key: id) as? E {
                                buttons(error)
                            } else {
                                []
                            }
                        }()
                    )
                }
            )
    }
    
    /// Modal component that presents alert with actions and hosts content.
    ///
    /// For additional info, refer to method with `Bool` presentation flag.
    public func vAlert<E, Content>(
        layerID: String? = nil,
        id: String,
        uiModel: VAlertUIModel = .init(),
        isPresented: Binding<Bool>,
        error: E?,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        title: @escaping (E) -> String?,
        message: @escaping (E) -> String?,
        @ViewBuilder content: @escaping (E) -> Content,
        @VAlertButtonBuilder actions buttons: @escaping (E) -> [VAlertButton]
    ) -> some View
        where
            E: Error,
            Content: View
    {
        error.map { PresentationHostDataSourceCache.shared.set(key: id, value: $0) }

        let isPresented: Binding<Bool> = .init(
            get: { isPresented.wrappedValue && error != nil },
            set: { if !$0 { isPresented.wrappedValue = false } }
        )

        return self
            .presentationHost(
                layerID: layerID,
                id: id,
                uiModel: uiModel.presentationHostSubUIModel,
                isPresented: isPresented,
                onPresent: presentHandler,
                onDismiss: dismissHandler,
                content: {
                    VAlert<Content>(
                        uiModel: uiModel,
                        isPresented: isPresented,
                        title: {
                            if let error = error ?? PresentationHostDataSourceCache.shared.get(key: id) as? E {
                                title(error)
                            } else {
                                ""
                            }
                        }(),
                        message: {
                            if let error = error ?? PresentationHostDataSourceCache.shared.get(key: id) as? E {
                                message(error)
                            } else {
                                ""
                            }
                        }(),
                        content: {
                            if let error = error ?? PresentationHostDataSourceCache.shared.get(key: id) as? E {
                                VAlertContent.content(content: { content(error) })
                            } else {
                                VAlertContent.empty
                            }
                        }(),
                        buttons: {
                            if let error = error ?? PresentationHostDataSourceCache.shared.get(key: id) as? E {
                                buttons(error)
                            } else {
                                []
                            }
                        }()
                    )
                }
            )
    }
}
