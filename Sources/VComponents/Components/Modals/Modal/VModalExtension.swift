//
//  VModalExtension.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/13/21.
//

import SwiftUI
import VCore

// MARK: - Bool
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {
    /// Presents modal when boolean is `true`.
    ///
    /// Modal component that draws a background, and hosts content.
    ///
    ///     @State private var isPresented: Bool = false
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { isPresented = true },
    ///             title: "Present"
    ///         )
    ///         .vModal(
    ///             id: "some_modal",
    ///             isPresented: $isPresented,
    ///             content: { ColorBook.accentBlue }
    ///         )
    ///     }
    ///
    /// Modal can also wrap it's content by reading geometry size.
    /// Although, the possibility of smaller screen sizes should be considered.
    ///
    ///     @State private var isPresented: Bool = false
    ///     @State private var contentHeight: CGFloat?
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { isPresented = true },
    ///             title: "Present"
    ///         )
    ///         .vModal(
    ///             id: "some_modal",
    ///             uiModel: {
    ///                 var uiModel: VModalUIModel = .init()
    ///
    ///                 uiModel.contentMargins = VModalUIModel.Margins(15)
    ///
    ///                 if let contentHeight {
    ///                     let height: CGFloat = uiModel.contentWrappingHeight(contentHeight: contentHeight)
    ///
    ///                     uiModel.sizes.portrait.height = .point(height)
    ///                     uiModel.sizes.landscape.height = .point(height)
    ///                 }
    ///
    ///                 return uiModel
    ///             }(),
    ///             isPresented: $isPresented,
    ///             content: {
    ///                 Text("...")
    ///                     .getSize({ contentHeight = $0.height })
    ///                     .onTapGesture(perform: { isPresented = false })
    ///             }
    ///         )
    ///     }
    ///     
    public func vModal<Content>(
        id: String,
        uiModel: VModalUIModel = .init(),
        isPresented: Binding<Bool>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View
        where Content: View
    {
        self
            .presentationHost(
                id: id,
                uiModel: uiModel.presentationHostUIModel,
                isPresented: isPresented,
                content: {
                    VModal<Content>(
                        uiModel: uiModel,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        content: content
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
    /// Presents modal using the item as data source for content.
    ///
    /// For additional info, refer to `View.vModal(id:isPresented:content:)`.
    public func vModal<Item, Content>(
        id: String,
        uiModel: VModalUIModel = .init(),
        item: Binding<Item?>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (Item) -> Content
    ) -> some View
        where
            Item: Identifiable,
            Content: View
    {
        item.wrappedValue.map { PresentationHostDataSourceCache.shared.set(key: id, value: $0) }
        
        return self
            .presentationHost(
                id: id,
                uiModel: uiModel.presentationHostUIModel,
                item: item,
                content: {
                    VModal<Content?>(
                        uiModel: uiModel,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        content: {
                            if let item = item.wrappedValue ?? PresentationHostDataSourceCache.shared.get(key: id) as? Item {
                                content(item)
                            }
                        }
                    )
                }
            )
    }
}
