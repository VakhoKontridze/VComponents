//
//  VModalExtension.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/13/21.
//

import SwiftUI

// MARK: - Bool
extension View {
    /// Presents `VModal` when boolean is `true`.
    ///
    /// Modal component that draws a background, and hosts content.
    ///
    /// Model, and present and dismiss handlers can be passed as parameters.
    ///
    /// `vModal` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
    ///
    /// Usage Example:
    ///
    ///     @State var isPresented: Bool = false
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { isPresented = true },
    ///             title: "Present"
    ///         )
    ///             .vModal(
    ///                 model: {
    ///                     var model: VModalModel = .init()
    ///                     model.misc.dismissType.remove(.leadingButton)
    ///                     model.misc.dismissType.remove(.trailingButton)
    ///                     return model
    ///                 }(),
    ///                 isPresented: $isPresented,
    ///                 content: {
    ///                     VList(data: 0..<20, content: { num in
    ///                         Text(String(num))
    ///                             .frame(maxWidth: .infinity, alignment: .leading)
    ///                     })
    ///                 }
    ///             )
    ///     }
    ///
    public func vModal<Content>(
        model: VModalModel = .init(),
        isPresented: Binding<Bool>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View
        where Content: View
    {
        self
            .onDisappear(perform: { PresentationHost.forceDismiss(in: self) })
            .background(PresentationHost(
                in: self,
                isPresented: isPresented,
                content: {
                    VModal<Never, _>(
                        model: model,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        headerLabel: .empty,
                        content: content
                    )
                }
            ))
    }
    
    /// Presents `VModal` when boolean is `true`.
    ///
    /// Modal component that draws a background, and hosts content.
    ///
    /// Model, and present and dismiss handlers can be passed as parameters.
    ///
    /// `vModal` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
    ///
    /// Usage Example:
    ///
    ///     @State var isPresented: Bool = false
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { isPresented = true },
    ///             title: "Present"
    ///         )
    ///             .vModal(
    ///                 isPresented: $isPresented,
    ///                 headerTitle: "Lorem Ipsum Dolor Sit Amet",
    ///                 content: {
    ///                     VList(data: 0..<20, content: { num in
    ///                         Text(String(num))
    ///                             .frame(maxWidth: .infinity, alignment: .leading)
    ///                     })
    ///                 }
    ///             )
    ///     }
    ///
    public func vModal<Content>(
        model: VModalModel = .init(),
        isPresented: Binding<Bool>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        headerTitle: String,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View
        where Content: View
    {
        self
            .onDisappear(perform: { PresentationHost.forceDismiss(in: self) })
            .background(PresentationHost(
                in: self,
                isPresented: isPresented,
                content: {
                    VModal<Never, _>(
                        model: model,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        headerLabel: .title(title: headerTitle),
                        content: content
                    )
                }
            ))
    }
    
    /// Presents `VModal` when boolean is `true`.
    ///
    /// Modal component that draws a background, and hosts content.
    ///
    /// Model, and present and dismiss handlers can be passed as parameters.
    ///
    /// `vModal` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
    ///
    /// Usage Example:
    ///
    ///     @State var isPresented: Bool = false
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { isPresented = true },
    ///             title: "Present"
    ///         )
    ///             .vModal(
    ///                 isPresented: $isPresented,
    ///                 headerLabel: {
    ///                     HStack(content: {
    ///                         Image(systemName: "swift")
    ///                         Text("Lorem Ipsum Dolor Sit Amet").lineLimit(1)
    ///                     })
    ///                 },
    ///                 content: {
    ///                     VList(data: 0..<20, content: { num in
    ///                         Text(String(num))
    ///                             .frame(maxWidth: .infinity, alignment: .leading)
    ///                     })
    ///                 }
    ///             )
    ///     }
    ///
    public func vModal<HeaderLabel, Content>(
        model: VModalModel = .init(),
        isPresented: Binding<Bool>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        @ViewBuilder headerLabel: @escaping () -> HeaderLabel,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View
        where
            HeaderLabel: View,
            Content: View
    {
        self
            .onDisappear(perform: { PresentationHost.forceDismiss(in: self) })
            .background(PresentationHost(
                in: self,
                isPresented: isPresented,
                content: {
                    VModal(
                        model: model,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        headerLabel: .custom(label: headerLabel),
                        content: content
                    )
                }
            ))
    }
}

// MARK: - Item
extension View {
    /// Presents `VModal` using the item as data source for content.
    ///
    /// Modal component that draws a background, and hosts content.
    ///
    /// Model, and present and dismiss handlers can be passed as parameters.
    ///
    /// `vModal` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
    ///
    /// Usage Example:
    ///
    ///     struct ModalItem: Identifiable {
    ///         let id: UUID = .init()
    ///     }
    ///
    ///     @State var modalItem: ModalItem?
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { modalItem = .init() },
    ///             title: "Present"
    ///         )
    ///             .vModal(
    ///                 model: {
    ///                     var model: VModalModel = .init()
    ///                     model.misc.dismissType.remove(.leadingButton)
    ///                     model.misc.dismissType.remove(.trailingButton)
    ///                     return model
    ///                 }(),
    ///                 item: $modalItem,
    ///                 content: { item in
    ///                     VList(data: 0..<20, content: { num in
    ///                         Text(String(num))
    ///                             .frame(maxWidth: .infinity, alignment: .leading)
    ///                     })
    ///                 }
    ///             )
    ///     }
    ///
    public func vModal<Item, Content>(
        model: VModalModel = .init(),
        item: Binding<Item?>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (Item) -> Content
    ) -> some View
        where
            Item: Identifiable,
            Content: View
    {
        item.wrappedValue.map { PresentationHostDataSourceCache.shared.set(key: self, value: $0) }

        return self
            .onDisappear(perform: { PresentationHost.forceDismiss(in: self) })
            .background(PresentationHost(
                in: self,
                isPresented: .init(
                    get: { item.wrappedValue != nil },
                    set: { if !$0 { item.wrappedValue = nil } }
                ),
                content: {
                    VModal<Never, _>(
                        model: model,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        headerLabel: .empty,
                        content: {
                            if let item = item.wrappedValue ?? PresentationHostDataSourceCache.shared.get(key: self) as? Item {
                                content(item)
                            }
                        }
                    )
                }
            ))
    }
    
    /// Presents `VModal` using the item as data source for content.
    ///
    /// Modal component that draws a background, and hosts content.
    ///
    /// Model, and present and dismiss handlers can be passed as parameters.
    ///
    /// `vModal` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
    ///
    /// Usage Example:
    ///
    ///     struct ModalItem: Identifiable {
    ///         let id: UUID = .init()
    ///     }
    ///
    ///     @State var modalItem: ModalItem?
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { modalItem = .init() },
    ///             title: "Present"
    ///         )
    ///             .vModal(
    ///                 item: $modalItem,
    ///                 headerTitle: { item in "Lorem Ipsum Dolor Sit Amet" },
    ///                 content: { item in
    ///                     VList(data: 0..<20, content: { num in
    ///                         Text(String(num))
    ///                             .frame(maxWidth: .infinity, alignment: .leading)
    ///                     })
    ///                 }
    ///             )
    ///     }
    ///
    public func vModal<Item, Content>(
        model: VModalModel = .init(),
        item: Binding<Item?>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        headerTitle: @escaping (Item) -> String,
        @ViewBuilder content: @escaping (Item) -> Content
    ) -> some View
        where
            Item: Identifiable,
            Content: View
    {
        item.wrappedValue.map { PresentationHostDataSourceCache.shared.set(key: self, value: $0) }
        
        return self
            .onDisappear(perform: { PresentationHost.forceDismiss(in: self) })
            .background(PresentationHost(
                in: self,
                isPresented: .init(
                    get: { item.wrappedValue != nil },
                    set: { if !$0 { item.wrappedValue = nil } }
                ),
                content: {
                    VModal<Never, _>(
                       model: model,
                       onPresent: presentHandler,
                       onDismiss: dismissHandler,
                       headerLabel: {
                           if let item = item.wrappedValue ?? PresentationHostDataSourceCache.shared.get(key: self) as? Item {
                               return .title(title: headerTitle(item))
                           } else {
                               return .empty
                           }
                       }(),
                       content: {
                           if let item = item.wrappedValue ?? PresentationHostDataSourceCache.shared.get(key: self) as? Item {
                               content(item)
                           }
                       }
                    )
                }
            ))
    }
    
    /// Presents `VModal` using the item as data source for content.
    ///
    /// Modal component that draws a background, and hosts content.
    ///
    /// Model, and present and dismiss handlers can be passed as parameters.
    ///
    /// `vModal` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
    ///
    /// Usage Example:
    ///
    ///     struct ModalItem: Identifiable {
    ///         let id: UUID = .init()
    ///     }
    ///
    ///     @State var modalItem: ModalItem?
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { modalItem = .init() },
    ///             title: "Present"
    ///         )
    ///             .vModal(
    ///                 item: $modalItem,
    ///                 headerLabel: { item in
    ///                     HStack(content: {
    ///                         Image(systemName: "swift")
    ///                         Text("Lorem Ipsum Dolor Sit Amet").lineLimit(1)
    ///                     })
    ///                 },
    ///                 content: { item in
    ///                     VList(data: 0..<20, content: { num in
    ///                         Text(String(num))
    ///                             .frame(maxWidth: .infinity, alignment: .leading)
    ///                     })
    ///                 }
    ///             )
    ///     }
    ///
    public func vModal<Item, HeaderLabel, Content>(
        model: VModalModel = .init(),
        item: Binding<Item?>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        @ViewBuilder headerLabel: @escaping (Item) -> HeaderLabel,
        @ViewBuilder content: @escaping (Item) -> Content
    ) -> some View
        where
            Item: Identifiable,
            HeaderLabel: View,
            Content: View
    {
        item.wrappedValue.map { PresentationHostDataSourceCache.shared.set(key: self, value: $0) }

        return self
            .onDisappear(perform: { PresentationHost.forceDismiss(in: self) })
            .background(PresentationHost(
                in: self,
                isPresented: .init(
                    get: { item.wrappedValue != nil },
                    set: { if !$0 { item.wrappedValue = nil } }
                ),
                content: {
                    VModal<HeaderLabel, _>(
                       model: model,
                       onPresent: presentHandler,
                       onDismiss: dismissHandler,
                       headerLabel: {
                           if let item = item.wrappedValue ?? PresentationHostDataSourceCache.shared.get(key: self) as? Item {
                               return .custom(label: { headerLabel(item) })
                           } else {
                               return .empty
                           }
                       }(),
                       content: {
                           if let item = item.wrappedValue ?? PresentationHostDataSourceCache.shared.get(key: self) as? Item {
                               content(item)
                           }
                       }
                    )
                }
            ))
    }
}
