//
//  View+VNotification.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 15.07.24.
//

import SwiftUI
import VCore

// MARK: - View + V Notification - Bool
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension View {
    /// Modal component that presents notification.
    ///
    ///     @State private var isPresented: Bool = false
    ///
    ///     var body: some View {
    ///         ZStack(content: {
    ///             VPlainButton(
    ///                 action: { isPresented = true },
    ///                 title: "Present"
    ///             )
    ///             .vNotification(
    ///                 layerID: "notifications",
    ///                 id: "some_notification",
    ///                 isPresented: $isPresented,
    ///                 icon: Image(systemName: "swift"),
    ///                 title: "Lorem Ipsum Dolor Sit Amet",
    ///                 message: "Lorem ipsum dolor sit amet"
    ///             )
    ///         })
    ///         .frame(maxWidth: .infinity, maxHeight: .infinity)
    ///         .presentationHostLayer( // Or declare in `App` on a `WindowScene`-level
    ///             id: "notifications",
    ///             uiModel: {
    ///                 var uiModel: PresentationHostLayerUIModel = .init()
    ///                 uiModel.dimmingViewTapAction = .passTapsThrough
    ///                 uiModel.dimmingViewColor = Color.clear
    ///                 return uiModel
    ///             }()
    ///         )
    ///     }
    ///
    /// Highlights can be applied using `info`, `success`, `warning`, and `error` instances of `VNotificationUIModel`.
    public func vNotification(
        layerID: String? = nil,
        id: String,
        uiModel: VNotificationUIModel = .init(),
        isPresented: Binding<Bool>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        icon: Image?,
        title: String?,
        message: String?
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
                    VNotification<Never>(
                        uiModel: uiModel,
                        isPresented: isPresented,
                        content: .iconTitleMessage(
                            icon: icon,
                            title: title,
                            message: message
                        )
                    )
                }
            )
    }

    /// Modal component that presents notification.
    ///
    /// For additional info, refer to method with `Bool` presentation flag.
    public func vNotification<CustomContent>(
        layerID: String? = nil,
        id: String,
        uiModel: VNotificationUIModel = .init(),
        isPresented: Binding<Bool>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        @ViewBuilder content customContent: @escaping () -> CustomContent
    ) -> some View
        where CustomContent: View
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
                    VNotification(
                        uiModel: uiModel,
                        isPresented: isPresented,
                        content: .custom(
                            custom: customContent
                        )
                    )
                }
            )
    }
}

// MARK: - View + V Notification - Item
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension View {
    /// Modal component that presents notification.
    ///
    /// For additional info, refer to method with `Bool` presentation flag.
    public func vNotification<Item>(
        layerID: String? = nil,
        id: String,
        uiModel: VNotificationUIModel = .init(),
        item: Binding<Item?>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        icon: @escaping (Item) -> Image?,
        title: @escaping (Item) -> String?,
        message: @escaping (Item) -> String?
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
                    VNotification<Never>(
                        uiModel: uiModel,
                        isPresented: isPresented,
                        content: .iconTitleMessage(
                            icon: {
                                if let item = item.wrappedValue ?? PresentationHostDataSourceCache.shared.get(key: id) as? Item {
                                    icon(item)
                                } else {
                                     nil
                                }
                            }(),
                            title: {
                                if let item = item.wrappedValue ?? PresentationHostDataSourceCache.shared.get(key: id) as? Item {
                                    title(item)
                                } else {
                                    nil
                                }
                            }(),
                            message: {
                                if let item = item.wrappedValue ?? PresentationHostDataSourceCache.shared.get(key: id) as? Item {
                                    message(item)
                                } else {
                                    nil
                                }
                            }()
                        )
                    )
                }
            )
    }

    /// Modal component that presents notification.
    ///
    /// For additional info, refer to method with `Bool` presentation flag.
    public func vNotification<Item, CustomContent>(
        layerID: String? = nil,
        id: String,
        uiModel: VNotificationUIModel = .init(),
        item: Binding<Item?>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        @ViewBuilder content customContent: @escaping (Item) -> CustomContent
    ) -> some View
        where CustomContent: View
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
                    VNotification(
                        uiModel: uiModel,
                        isPresented: isPresented,
                        content: .custom(
                            custom: {
                                Group(content: {
                                    if let item = item.wrappedValue ?? PresentationHostDataSourceCache.shared.get(key: id) as? Item {
                                        customContent(item)
                                    }
                                })
                            }
                        )
                    )
                }
            )
    }
}
