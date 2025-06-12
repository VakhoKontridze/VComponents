//
//  View+VToast.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/7/21.
//

import SwiftUI
import VCore

// MARK: - View + V Toast - Bool
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension View {
    /// Modal component that presents toast.
    ///
    ///     @State private var isPresented: Bool = false
    ///
    ///     var body: some View {
    ///         ZStack {
    ///             VPlainButton(
    ///                 action: { isPresented = true },
    ///                 title: "Present"
    ///             )
    ///             .vToast(
    ///                 link: .window(rootID: "notifications", linkID: "some_toast"),
    ///                 isPresented: $isPresented,
    ///                 text: "Lorem ipsum dolor sit amet"
    ///             )
    ///         }
    ///         .frame(maxWidth: .infinity, maxHeight: .infinity) // For `overlay` configuration
    ///         .modalPresenterRoot( // Or declare in `App` on a `WindowScene`-level
    ///             root: .window(rootID: "notifications"),
    ///             uiModel: {
    ///                 var uiModel: ModalPresenterRootUIModel = .init()
    ///                 uiModel.dimmingViewColor = Color.clear
    ///                 uiModel.dimmingViewTapAction = .passTapsThrough
    ///                 return uiModel
    ///             }()
    ///         )
    ///     }
    ///
    /// Highlights can be applied using `info`, `success`, `warning`, and `error` instances of `VToastUIModel`.
    public func vToast(
        link: ModalPresenterLink,
        uiModel: VToastUIModel = .init(),
        isPresented: Binding<Bool>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        text: String
    ) -> some View {
        self
            .modalPresenterLink(
                link: link,
                uiModel: uiModel.modalPresenterLinkUIModel,
                isPresented: isPresented,
                onPresent: presentHandler,
                onDismiss: dismissHandler
            ) {
                VToast(
                    uiModel: uiModel,
                    isPresented: isPresented,
                    text: text
                )
            }
    }
}

// MARK: - View + V Toast - Item
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension View {
    /// Modal component that presents toast.
    ///
    /// For additional info, refer to method with `Bool` presentation flag.
    public func vToast<Item>(
        link: ModalPresenterLink,
        uiModel: VToastUIModel = .init(),
        item: Binding<Item?>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        text: @escaping (Item) -> String
    ) -> some View {
        item.wrappedValue.map { ModalPresenterDataSourceCache.shared.set(key: link.linkID, value: $0) }

        let isPresented: Binding<Bool> = .init(
            get: { item.wrappedValue != nil },
            set: { if !$0 { item.wrappedValue = nil } }
        )

        return self
            .modalPresenterLink(
                link: link,
                uiModel: uiModel.modalPresenterLinkUIModel,
                isPresented: isPresented,
                onPresent: presentHandler,
                onDismiss: dismissHandler
            ) {
                VToast(
                    uiModel: uiModel,
                    isPresented: isPresented,
                    text: {
                        if let item = item.wrappedValue ?? ModalPresenterDataSourceCache.shared.get(key: link.linkID) as? Item {
                            text(item)
                        } else {
                            ""
                        }
                    }()
                )
            }
    }
}

// MARK: - View + V Toast - Error
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension View {
    /// Modal component that presents toast.
    ///
    /// For additional info, refer to method with `Bool` presentation flag.
    public func vToast<E>(
        link: ModalPresenterLink,
        uiModel: VToastUIModel = .init(),
        isPresented: Binding<Bool>,
        error: E?,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        text: @escaping (E) -> String
    ) -> some View
        where E: Error
    {
        error.map { ModalPresenterDataSourceCache.shared.set(key: link.linkID, value: $0) }

        let isPresented: Binding<Bool> = .init(
            get: { isPresented.wrappedValue && error != nil },
            set: { if !$0 { isPresented.wrappedValue = false } }
        )

        return self
            .modalPresenterLink(
                link: link,
                uiModel: uiModel.modalPresenterLinkUIModel,
                isPresented: isPresented,
                onPresent: presentHandler,
                onDismiss: dismissHandler
            ) {
                VToast(
                    uiModel: uiModel,
                    isPresented: isPresented,
                    text: {
                        if let error = error ?? ModalPresenterDataSourceCache.shared.get(key: link.linkID) as? E {
                            text(error)
                        } else {
                            ""
                        }
                    }()
                )
            }
    }
}
