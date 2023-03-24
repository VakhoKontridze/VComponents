//
//  VToastExtension.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/7/21.
//

import SwiftUI
import VCore

// MARK: - Bool
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {
    /// Presents toast when `Bool` is `true`.
    ///
    /// Modal component that presents toast, and hosts content.
    ///
    /// UI Model, and present and dismiss handlers can be passed as parameters.
    ///
    /// `vToast` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
    ///
    ///     @State private var isPresented: Bool = false
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { isPresented = true },
    ///             title: "Present"
    ///         )
    ///             .vToast(
    ///                 id: "some_toast",
    ///                 isPresented: $isPresented,
    ///                 text: "Lorem ipsum dolor sit amet"
    ///             )
    ///     }
    ///
    /// You can apply highlights by using `success`, `warning`, and `secure` instances of `VToastUIModel`.
    ///
    public func vToast(
        id: String,
        uiModel: VToastUIModel = .init(),
        isPresented: Binding<Bool>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        text: String
    ) -> some View {
        self
            .presentationHost(
                id: id,
                allowsHitTests: false,
                isPresented: isPresented,
                content: {
                    VToast(
                        uiModel: uiModel,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        text: text
                    )
                }
            )
    }
}

// MARK: - Item
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {
    /// Presents toast using the item as data source for content.
    ///
    /// Modal component that presents toast, and hosts content.
    ///
    /// UI Model, and present and dismiss handlers can be passed as parameters.
    ///
    /// `vToast` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
    ///
    ///     struct ToastItem: Identifiable {
    ///         let id: UUID = .init()
    ///     }
    ///
    ///     @State private var toastItem: ToastItem?
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { toastItem = .init() },
    ///             title: "Present"
    ///         )
    ///             .vToast(
    ///                 id: "some_toast",
    ///                 item: $toastItem,
    ///                 text: { item in "Lorem ipsum dolor sit amet" }
    ///             )
    ///     }
    ///
    /// You can apply highlights by using `success`, `warning`, and `secure` instances of `VToastUIModel`.
    ///
    public func vToast<Item>(
        id: String,
        uiModel: VToastUIModel = .init(),
        item: Binding<Item?>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        text: @escaping (Item) -> String
    ) -> some View
        where Item: Identifiable
    {
        item.wrappedValue.map { PresentationHostDataSourceCache.shared.set(key: id, value: $0) }

        return self
            .presentationHost(
                id: id,
                allowsHitTests: false,
                item: item,
                content: {
                    VToast(
                        uiModel: uiModel,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        text: {
                            if let item = item.wrappedValue ?? PresentationHostDataSourceCache.shared.get(key: id) as? Item {
                                return text(item)
                            } else {
                                return ""
                            }
                        }()
                    )
                }
            )
    }
}

// MARK: - Presenting Data
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {
    /// Presents toast when `Bool` is `true` using data to produce content.
    ///
    /// Modal component that presents toast, and hosts content.
    ///
    /// UI Model, and present and dismiss handlers can be passed as parameters.
    ///
    /// `vToast` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
    ///
    /// For the toast to appear, both `isPresented` must be true and `data` must not be nil.
    /// The `data` should not change after the presentation occurs.
    /// Any changes that you make after the presentation occurs are ignored.
    ///
    ///     struct ToastData {}
    ///
    ///     @State private var isPresented: Bool = false
    ///
    ///     @State private var toastData: ToastData?
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { isPresented = true; toastData = .init() },
    ///             title: "Present"
    ///         )
    ///             .vToast(
    ///                 id: "some_toast",
    ///                 isPresented: $isPresented,
    ///                 presenting: toastData,
    ///                 text: { data in "Lorem ipsum dolor sit amet" }
    ///             )
    ///     }
    ///
    /// You can apply highlights by using `success`, `warning`, and `secure` instances of `VToastUIModel`.
    ///
    public func vToast<T>(
        id: String,
        uiModel: VToastUIModel = .init(),
        isPresented: Binding<Bool>,
        presenting data: T?,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        text: @escaping (T) -> String
    ) -> some View {
        data.map { PresentationHostDataSourceCache.shared.set(key: id, value: $0) }

        return self
            .presentationHost(
                id: id,
                allowsHitTests: false,
                isPresented: isPresented,
                presenting: data,
                content: {
                    VToast(
                        uiModel: uiModel,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        text: {
                            if let data = data ?? PresentationHostDataSourceCache.shared.get(key: id) as? T {
                                return text(data)
                            } else {
                                return ""
                            }
                        }()
                    )
                }
            )
    }
}

// MARK: - Error
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {
    /// Presents toast when `Bool` is `true` using `Error`
    ///
    /// Modal component that presents toast, and hosts content.
    ///
    /// UI Model, and present and dismiss handlers can be passed as parameters.
    ///
    /// `vToast` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
    ///
    /// For the toast to appear, both `isPresented` must be true and `error` must not be nil.
    /// The `error` should not change after the presentation occurs.
    /// Any changes that you make after the presentation occurs are ignored.
    ///
    ///     @State private var isPresented: Bool = false
    ///
    ///     @State private var toastError: Error?
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { isPresented = true; toastError = SomeError() },
    ///             title: "Present"
    ///         )
    ///             .vToast(
    ///                 id: "some_toast",
    ///                 isPresented: $isPresented,
    ///                 error: toastError,
    ///                 text: { error in "Lorem ipsum dolor sit amet" }
    ///             )
    ///     }
    ///
    /// You can apply highlights by using `success`, `warning`, and `secure` instances of `VToastUIModel`.
    ///
    public func vToast<E>(
        id: String,
        uiModel: VToastUIModel = .init(),
        isPresented: Binding<Bool>,
        error: E?,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        text: @escaping (E) -> String
    ) -> some View
        where E: Error
    {
        error.map { PresentationHostDataSourceCache.shared.set(key: id, value: $0) }

        return self
            .presentationHost(
                id: id,
                allowsHitTests: false,
                isPresented: isPresented,
                error: error,
                content: {
                    VToast(
                        uiModel: uiModel,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        text: {
                            if let error = error ?? PresentationHostDataSourceCache.shared.get(key: id) as? E {
                                return text(error)
                            } else {
                                return ""
                            }
                        }()
                    )
                }
            )
    }
}
