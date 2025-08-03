//
//  View+VModal.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/13/21.
//

import SwiftUI
import VCore

@available(watchOS, unavailable)
extension View {
    /// Modal component that hosts slide-able content on the edge of the container.
    ///
    ///     @State private var isPresented: Bool = false
    ///
    ///     var body: some View {
    ///         ZStack {
    ///             VPlainButton(
    ///                 action: { isPresented = true },
    ///                 title: "Present"
    ///             )
    ///             .vModal(
    ///                 link: .window(linkID: "modal"),
    ///                 isPresented: $isPresented
    ///             ) {
    ///                 Color.blue
    ///             }
    ///         }
    ///         .frame(maxWidth: .infinity, maxHeight: .infinity) // For `overlay` configuration
    ///         .modalPresenterRoot(root: .window()) // Or declare in `App` on a `WindowScene`-level
    ///     }
    ///
    /// Modal can also wrap navigation system.
    ///
    ///     @State private var isPresented: Bool = false
    ///     @State private var modalDidAppear: Bool = false
    ///
    ///     var body: some View {
    ///         ZStack {
    ///             VPlainButton(
    ///                 action: { isPresented = true },
    ///                 title: "Present"
    ///             )
    ///             .vModal(
    ///                 link: .window(linkID: "modal"),
    ///                 isPresented: $isPresented,
    ///                 onPresent: { modalDidAppear = true },
    ///                 onDismiss: { modalDidAppear = false }
    ///             ) {
    ///                 NavigationStack {
    ///                     HomeView(isPresented: $isPresented)
    ///                         // Disables possible `NavigationStack` animations
    ///                         .transaction {
    ///                             if !modalDidAppear { $0.animation = nil }
    ///                         }
    ///                     }
    ///                 }
    ///             }
    ///         }
    ///         .frame(maxWidth: .infinity, maxHeight: .infinity) // For `overlay` configuration
    ///         .modalPresenterRoot(root: .window()) // Or declare in `App` on a `WindowScene`-level
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
    ///             .toolbar {
    ///                 VPlainButton(
    ///                     action: { isPresented = false },
    ///                     title: "Dismiss"
    ///                 )
    ///             }
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
    ///                 action: dismissAction,
    ///                 title: "To Home"
    ///             )
    ///             .inlineNavigationTitle("Destination")
    ///             .toolbar {
    ///                 VPlainButton(
    ///                     action: { isPresented = false },
    ///                     title: "Dismiss"
    ///                 )
    ///             }
    ///         }
    ///     }
    ///     
    public func vModal<Content>(
        link: ModalPresenterLink,
        appearance: VModalAppearance = .init(),
        isPresented: Binding<Bool>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View
        where Content: View
    {
        self
            .modalPresenterLink(
                link: link,
                appearance: appearance.modalPresenterLinkAppearance,
                isPresented: isPresented,
                onPresent: presentHandler,
                onDismiss: dismissHandler
            ) {
                VModal<Content>(
                    appearance: appearance,
                    isPresented: isPresented,
                    content: content
                )
            }
    }
}

@available(watchOS, unavailable)
extension View {
    /// Modal component that hosts slide-able content on the edge of the container.
    ///
    /// For additional info, refer to method with `Bool` presentation flag.
    public func vModal<Item, Content>(
        link: ModalPresenterLink,
        appearance: @escaping (Item) -> VModalAppearance = { _ in VModalAppearance() },
        item: Binding<Item?>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (Item) -> Content
    ) -> some View
        where
            Item: Equatable,
            Content: View
    {
        let isPresented: Binding<Bool> = .init(
            get: { item.wrappedValue != nil },
            set: { if !$0 { item.wrappedValue = nil } }
        )

        return self
            .withLastNonNil(item.wrappedValue) { (view, item) in
                let appearance: VModalAppearance = item.map(appearance) ?? VModalAppearance()
                let content: () -> Content? = { item.map(content) }
                
                view
                    .modalPresenterLink(
                        link: link,
                        appearance: appearance.modalPresenterLinkAppearance,
                        isPresented: isPresented,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler
                    ) {
                        VModal(
                            appearance: appearance,
                            isPresented: isPresented,
                            content: content
                        )
                    }
            }
    }
}
