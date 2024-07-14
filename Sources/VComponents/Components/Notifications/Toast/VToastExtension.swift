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
@available(visionOS, unavailable)
extension View {
    /// Modal component that presents toast.
    ///
    ///     @State private var isPresented: Bool = false
    ///
    ///     var body: some View {
    ///         ZStack(content: {
    ///             VPlainButton(
    ///                 action: { isPresented = true },
    ///                 title: "Present"
    ///             )
    ///             .vToast(
    ///                 layerID: "notifications",
    ///                 id: "some_toast",
    ///                 isPresented: $isPresented,
    ///                 text: "Lorem ipsum dolor sit amet"
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
    /// Width can be configured via `widthType` in UI model.
    ///
    /// Highlights can be applied using `success`, `warning`, and `error` instances of `VToastUIModel`.
    public func vToast(
        layerID: String? = nil,
        id: String,
        uiModel: VToastUIModel = .init(),
        isPresented: Binding<Bool>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        text: String
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
                    VToast(
                        uiModel: uiModel,
                        isPresented: isPresented,
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
@available(visionOS, unavailable)
extension View {
    /// Modal component that presents toast.
    ///
    /// For additional info, refer to `View.vToast(id:isPresented:text:)`.
    public func vToast<Item>(
        layerID: String? = nil,
        id: String,
        uiModel: VToastUIModel = .init(),
        item: Binding<Item?>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        text: @escaping (Item) -> String
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
                    VToast(
                        uiModel: uiModel,
                        isPresented: isPresented,
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

// MARK: - Error
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension View {
    /// Modal component that presents toast.
    ///
    /// For additional info, refer to `View.vToast(id:isPresented:text:)`.
    public func vToast<E>(
        layerID: String? = nil,
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
                    VToast(
                        uiModel: uiModel,
                        isPresented: isPresented,
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
