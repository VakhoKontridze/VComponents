//
//  VToastExtension.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/7/21.
//

import SwiftUI
import VCore

// MARK: - Bool
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {
    /// Modal component that presents toast.
    ///
    ///     @State private var isPresented: Bool = false
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { isPresented = true },
    ///             title: "Present"
    ///         )
    ///         .vToast(
    ///             id: "some_toast",
    ///             isPresented: $isPresented,
    ///             text: "Lorem ipsum dolor sit amet"
    ///         )
    ///     }
    ///
    /// Width can be configured via `widthType` in UI model.
    ///
    /// Highlights can be applied using `success`, `warning`, and `error` instances of `VToastUIModel`.
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
                uiModel: uiModel.presentationHostUIModel,
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
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {
    /// Modal component that presents toast.
    ///
    /// For additional info, refer to `View.vToast(id:isPresented:text:)`.
    public func vToast<Item>(
        id: String,
        uiModel: VToastUIModel = .init(),
        item: Binding<Item?>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        text: @escaping (Item) -> String
    ) -> some View {
        item.wrappedValue.map { PresentationHostDataSourceCache.shared.set(key: id, value: $0) }
        
        return self
            .presentationHost(
                id: id,
                uiModel: uiModel.presentationHostUIModel,
                item: item,
                content: {
                    VToast(
                        uiModel: uiModel,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        text: {
                            if let item = item.wrappedValue ?? PresentationHostDataSourceCache.shared.get(key: id) as? Item {
                                text(item)
                            } else {
                                ""
                            }
                        }()
                    )
                }
            )
    }
}

// MARK: - Presenting Data
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {
    /// Modal component that presents toast.
    ///
    /// For additional info, refer to `View.vToast(id:isPresented:text:)`.
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
                uiModel: uiModel.presentationHostUIModel,
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
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {
    /// Modal component that presents toast.
    ///
    /// For additional info, refer to `View.vToast(id:isPresented:text:)`.
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
                uiModel: uiModel.presentationHostUIModel,
                isPresented: isPresented,
                error: error,
                content: {
                    VToast(
                        uiModel: uiModel,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        text: {
                            if let error = error ?? PresentationHostDataSourceCache.shared.get(key: id) as? E {
                                text(error)
                            } else {
                                ""
                            }
                        }()
                    )
                }
            )
    }
}
