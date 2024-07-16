//
//  VModalExtension.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/13/21.
//

import SwiftUI
import VCore

// MARK: - Bool
@available(watchOS, unavailable)
extension View {
    /// Modal component that hosts slide-able content on the edge of the container.
    ///
    ///     @State private var isPresented: Bool = false
    ///
    ///     var body: some View {
    ///         ZStack(content: {
    ///             VPlainButton(
    ///                 action: { isPresented = true },
    ///                 title: "Present"
    ///             )
    ///             .vModal(
    ///                 id: "some_modal",
    ///                 isPresented: $isPresented,
    ///                 content: { Color.blue }
    ///             )
    ///         })
    ///         .frame(maxWidth: .infinity, maxHeight: .infinity)
    ///         .presentationHostLayer() // Or declare in `App` on a `WindowScene`-level
    ///     }
    ///
    /// Modal can also wrap it's content by reading geometry size.
    /// Although, the possibility of smaller screen sizes should be considered.
    ///
    ///     @State private var isPresented: Bool = false
    ///     @State private var contentHeight: CGFloat?
    ///
    ///     var body: some View {
    ///         ZStack(content: {
    ///             VPlainButton(
    ///                 action: { isPresented = true },
    ///                 title: "Present"
    ///             )
    ///             .vModal(
    ///                 id: "some_modal",
    ///                 uiModel: {
    ///                     var uiModel: VModalUIModel = .init()
    ///
    ///                     uiModel.contentMargins = VModalUIModel.Margins(15)
    ///
    ///                     if let contentHeight {
    ///                         let height: CGFloat = uiModel.contentWrappingHeight(contentHeight: contentHeight)
    ///
    ///                         uiModel.sizes.portrait.height = .absolute(height)
    ///                         uiModel.sizes.landscape.height = .absolute(height)
    ///                     }
    ///
    ///                     return uiModel
    ///                 }(),
    ///                 isPresented: $isPresented,
    ///                 content: {
    ///                     Text("...")
    ///                         .getSize({ contentHeight = $0.height })
    ///                         .onTapGesture(perform: { isPresented = false })
    ///                 }
    ///             )
    ///         })
    ///         .frame(maxWidth: .infinity, maxHeight: .infinity)
    ///         .presentationHostLayer() // Or declare in `App` on a `WindowScene`-level
    ///     }
    ///
    /// Modal can also wrap navigation system.
    ///
    ///     @State private var isPresented: Bool = false
    ///     @State private var modalDidAppear: Bool = false
    ///
    ///     var body: some View {
    ///         ZStack(content: {
    ///             VPlainButton(
    ///                 action: { isPresented = true },
    ///                 title: "Present"
    ///             )
    ///             .vModal(
    ///                 id: "test",
    ///                 isPresented: $isPresented,
    ///                 onPresent: { modalDidAppear = true },
    ///                 onDismiss: { modalDidAppear = false },
    ///                 content: {
    ///                     NavigationStack(root: {
    ///                         HomeView(isPresented: $isPresented)
    ///                             // Disables possible `NavigationStack` animations
    ///                             .transaction({
    ///                                 if !modalDidAppear { $0.animation = nil }
    ///                          })
    ///                     })
    ///                 }
    ///             )
    ///         })
    ///         .frame(maxWidth: .infinity, maxHeight: .infinity)
    ///         .presentationHostLayer() // Or declare in `App` on a `WindowScene`-level
    ///     }
    ///
    ///     struct HomeView: View {
    ///         @Binding private var isPresented: Bool
    ///
    ///         init(isPresented: Binding<Bool>) {
    ///             self._isPresented = isPresented
    ///         }
    ///
    ///         var body: some View {
    ///             NavigationLink(
    ///                 "To Destination",
    ///                 destination: { DestinationView(isPresented: $isPresented) }
    ///             )
    ///             .inlineNavigationTitle("Home")
    ///             .toolbar(content: {
    ///                 VPlainButton(
    ///                     action: { isPresented = false },
    ///                     title: "Dismiss"
    ///                 )
    ///             })
    ///         }
    ///     }
    ///
    ///     struct DestinationView: View {
    ///         @Environment(\.dismiss) private var dismissAction: DismissAction
    ///
    ///         @Binding private var isPresented: Bool
    ///
    ///         init(isPresented: Binding<Bool>) {
    ///             self._isPresented = isPresented
    ///         }
    ///
    ///         var body: some View {
    ///             VPlainButton(
    ///                 action: { dismissAction.callAsFunction() },
    ///                 title: "To Home"
    ///             )
    ///             .inlineNavigationTitle("Destination")
    ///             .toolbar(content: {
    ///                 VPlainButton(
    ///                     action: { isPresented = false },
    ///                     title: "Dismiss"
    ///                 )
    ///             })
    ///         }
    ///     }
    ///     
    public func vModal<Content>(
        layerID: String? = nil,
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
                layerID: layerID,
                id: id,
                uiModel: uiModel.presentationHostSubUIModel,
                isPresented: isPresented,
                onPresent: presentHandler,
                onDismiss: dismissHandler,
                content: {
                    VModal<Content>(
                        uiModel: uiModel,
                        isPresented: isPresented,
                        content: content
                    )
                }
            )
    }
}

// MARK: - Item
@available(watchOS, unavailable)
extension View {
    /// Modal component that hosts slide-able content on the edge of the container.
    ///
    /// For additional info, refer to method with `Bool` presentation flag.
    public func vModal<Item, Content>(
        layerID: String? = nil,
        id: String,
        uiModel: VModalUIModel = .init(),
        item: Binding<Item?>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (Item) -> Content
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
                    VModal<Content?>(
                        uiModel: uiModel,
                        isPresented: isPresented,
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
