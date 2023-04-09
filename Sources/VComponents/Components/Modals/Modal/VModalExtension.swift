//
//  VModalExtension.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/13/21.
//

import SwiftUI
import VCore

// MARK: - Bool
extension View {
    /// Presents modal when boolean is `true`.
    ///
    /// Modal component that draws a background, and hosts content.
    ///
    /// UI Model, and present and dismiss handlers can be passed as parameters.
    ///
    /// `vModal` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
    ///
    ///     @State private var isPresented: Bool = false
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { isPresented = true },
    ///             title: "Present"
    ///         )
    ///             .vModal(
    ///                 id: "some_modal",
    ///                 isPresented: $isPresented,
    ///                 content: {
    ///                     List(content: {
    ///                         ForEach(0..<20, content: { num in
    ///                             VListRow(uiModel: .noFirstAndLastSeparators(isFirst: num == 0), content: {
    ///                                 Text(String(num))
    ///                                     .frame(maxWidth: .infinity, alignment: .leading)
    ///                             })
    ///                         })
    ///                     })
    ///                         .vListStyle()
    ///                         .vModalHeaderTitle("Lorem Ipsum Dolor Sit Amet")
    ///                 }
    ///             )
    ///     }
    ///
    public func vModal(
        id: String,
        uiModel: VModalUIModel = .init(),
        isPresented: Binding<Bool>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> some View
    ) -> some View {
        self
            .presentationHost(
                id: id,
                isPresented: isPresented,
                content: {
                    VModal<_>(
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
extension View {
    /// Presents modal using the item as data source for content.
    ///
    /// Modal component that draws a background, and hosts content.
    ///
    /// UI Model, and present and dismiss handlers can be passed as parameters.
    ///
    /// `vModal` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
    ///
    ///     struct ModalItem: Identifiable {
    ///         let id: UUID = .init()
    ///     }
    ///
    ///     @State private var modalItem: ModalItem?
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { modalItem = .init() },
    ///             title: "Present"
    ///         )
    ///             .vModal(
    ///                 id: "some_modal",
    ///                 item: $modalItem,
    ///                 content: { item in
    ///                     List(content: {
    ///                         ForEach(0..<20, content: { num in
    ///                             VListRow(uiModel: .noFirstAndLastSeparators(isFirst: num == 0), content: {
    ///                                 Text(String(num))
    ///                                     .frame(maxWidth: .infinity, alignment: .leading)
    ///                             })
    ///                         })
    ///                     })
    ///                         .vListStyle()
    ///                         .vModalHeaderTitle("Lorem Ipsum Dolor Sit Amet")
    ///                 }
    ///             )
    ///     }
    ///
    public func vModal<Item>(
        id: String,
        uiModel: VModalUIModel = .init(),
        item: Binding<Item?>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (Item) -> some View
    ) -> some View
        where Item: Identifiable
    {
        item.wrappedValue.map { PresentationHostDataSourceCache.shared.set(key: id, value: $0) }

        return self
            .presentationHost(
                id: id,
                item: item,
                content: {
                    VModal<_>(
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
