//
//  View+VNotification.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 15.07.24.
//

import SwiftUI
import VCore

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
    ///         ZStack {
    ///             VPlainButton(
    ///                 action: { isPresented = true },
    ///                 title: "Present"
    ///             )
    ///             .vNotification(
    ///                 link: .window(rootID: "notifications", linkID: "notification"),
    ///                 isPresented: $isPresented,
    ///                 image: Image(systemName: "swift"),
    ///                 title: "Lorem Ipsum Dolor Sit Amet",
    ///                 message: "Lorem ipsum dolor sit amet"
    ///             )
    ///         }
    ///         .frame(maxWidth: .infinity, maxHeight: .infinity) // For `overlay` configuration
    ///         .modalPresenterRoot( // Or declare in `App` on a `WindowScene`-level
    ///             root: .window(rootID: "notifications"),
    ///             appearance: {
    ///                 var appearance: ModalPresenterRootAppearance = .init()
    ///                 appearance.dimmingViewColor = Color.clear
    ///                 appearance.dimmingViewTapAction = .passTapsThrough
    ///                 return appearance
    ///             }()
    ///         )
    ///     }
    ///
    /// Highlights can be applied using `info`, `success`, `warning`, and `error` instances of `VNotificationAppearance`.
    public func vNotification(
        link: ModalPresenterLink,
        appearance: VNotificationAppearance = .init(),
        isPresented: Binding<Bool>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        image: Image?,
        title: String?,
        message: String?
    ) -> some View {
        self
            .modalPresenterLink(
                link: link,
                appearance: appearance.modalPresenterLinkAppearance,
                isPresented: isPresented,
                onPresent: presentHandler,
                onDismiss: dismissHandler
            ) {
                VNotification<Never>(
                    appearance: appearance,
                    isPresented: isPresented,
                    content: .imageAndTitleAndMessage(
                        image: image,
                        title: title,
                        message: message
                    )
                )
            }
    }

    /// Modal component that presents notification.
    ///
    /// For additional info, refer to method with `Bool` presentation flag.
    public func vNotification<CustomContent>(
        link: ModalPresenterLink,
        appearance: VNotificationAppearance = .init(),
        isPresented: Binding<Bool>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        @ViewBuilder content customContent: @escaping () -> CustomContent
    ) -> some View
        where CustomContent: View
    {
        self
            .modalPresenterLink(
                link: link,
                appearance: appearance.modalPresenterLinkAppearance,
                isPresented: isPresented,
                onPresent: presentHandler,
                onDismiss: dismissHandler
            ) {
                VNotification(
                    appearance: appearance,
                    isPresented: isPresented,
                    content: .custom(
                        builder: customContent
                    )
                )
            }
    }
}

@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension View {
    /// Modal component that presents notification.
    ///
    /// For additional info, refer to method with `Bool` presentation flag.
    public func vNotification<Item>(
        link: ModalPresenterLink,
        appearance: @escaping (Item) -> VNotificationAppearance = { _ in VNotificationAppearance() },
        item: Binding<Item?>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        image: @escaping (Item) -> Image?,
        title: @escaping (Item) -> String?,
        message: @escaping (Item) -> String?
    ) -> some View
        where Item: Equatable
    {
        let isPresented: Binding<Bool> = .init(
            get: { item.wrappedValue != nil },
            set: { if !$0 { item.wrappedValue = nil } }
        )

        return self
            .withLastNonNil(item.wrappedValue) { (view, item) in
                let appearance: VNotificationAppearance = item.map(appearance) ?? VNotificationAppearance()
                let image: Image? = item.flatMap(image)
                let title: String? = item.flatMap(title)
                let message: String? = item.flatMap(message)
                
                view
                    .modalPresenterLink(
                        link: link,
                        appearance: appearance.modalPresenterLinkAppearance,
                        isPresented: isPresented,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler
                    ) {
                        VNotification<Never>(
                            appearance: appearance,
                            isPresented: isPresented,
                            content: .imageAndTitleAndMessage(
                                image: image,
                                title: title,
                                message: message
                            )
                        )
                    }
            }
    }

    /// Modal component that presents notification.
    ///
    /// For additional info, refer to method with `Bool` presentation flag.
    public func vNotification<Item, CustomContent>(
        link: ModalPresenterLink,
        appearance: @escaping (Item) -> VNotificationAppearance = { _ in VNotificationAppearance() },
        item: Binding<Item?>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        @ViewBuilder content customContent: @escaping (Item) -> CustomContent
    ) -> some View
        where
            Item: Equatable,
            CustomContent: View
    {
        let isPresented: Binding<Bool> = .init(
            get: { item.wrappedValue != nil },
            set: { if !$0 { item.wrappedValue = nil } }
        )

        return self
            .withLastNonNil(item.wrappedValue) { (view, item) in
                let appearance: VNotificationAppearance = item.map(appearance) ?? VNotificationAppearance()
                let content: VNotificationContent = .custom(builder: { Group { item.map { customContent($0) } } })
                
                view
                    .modalPresenterLink(
                        link: link,
                        appearance: appearance.modalPresenterLinkAppearance,
                        isPresented: isPresented,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler
                    ) {
                        VNotification(
                            appearance: appearance,
                            isPresented: isPresented,
                            content: content
                        )
                    }
            }
    }
}
