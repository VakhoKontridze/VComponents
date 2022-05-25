//
//  VModal.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/13/21.
//

import SwiftUI

// MARK: - V Modal
/// Modal component that draws a background, hosts content, and is present when condition is `true`.
///
/// Model and header can be passed as parameters.
///
/// `vModal` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
///
/// Usage example:
///
///     @State var isPresented: Bool = false
///
///     var body: some View {
///         VPlainButton(
///             action: { isPresented = true },
///             title: "Present"
///         )
///             .vModal(isPresented: $isPresented, modal: {
///                 VModal(
///                     headerTitle: "Lorem ipsum dolor sit amet",
///                     content: {
///                         VList(data: 0..<20, content: { num in
///                             Text(String(num))
///                                 .frame(maxWidth: .infinity, alignment: .leading)
///                         })
///                     }
///                 )
///             })
///     }
///
public struct VModal<HeaderLabel, Content>
    where
        HeaderLabel: View,
        Content: View
{
    // MARK: Properties
    fileprivate let model: VModalModel
    
    fileprivate let headerLabel: VModalHeaderLabel<HeaderLabel>
    fileprivate let content: () -> Content
    
    // MARK: Initializers
    /// Initializes component content.
    public init(
        model: VModalModel = .init(),
        @ViewBuilder content: @escaping () -> Content
    )
        where HeaderLabel == Never
    {
        self.model = model
        self.headerLabel = .empty
        self.content = content
    }
    
    /// Initializes component with header title and content.
    public init(
        model: VModalModel = .init(),
        headerTitle: String,
        @ViewBuilder content: @escaping () -> Content
    )
        where HeaderLabel == Never
    {
        self.model = model
        self.headerLabel = .title(title: headerTitle)
        self.content = content
    }
    
    /// Initializes component with header and content.
    public init(
        model: VModalModel = .init(),
        @ViewBuilder headerLabel: @escaping () -> HeaderLabel,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.model = model
        self.headerLabel = .custom(label: headerLabel)
        self.content = content
    }
}

// MARK: - Extension
extension View {
    /// Presents `VModal` when boolean is `true`.
    public func vModal<HeaderLabel, Content>(
        isPresented: Binding<Bool>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        modal: @escaping () -> VModal<HeaderLabel, Content>
    ) -> some View
        where
            HeaderLabel: View,
            Content: View
    {
        self
            .background(PresentationHost(
                isPresented: isPresented,
                content: { () -> _VModal<HeaderLabel, Content> in
                    let modal = modal()
                    
                    return _VModal(
                        model: modal.model,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        headerLabel: modal.headerLabel,
                        content: modal.content
                    )
                }
            ))
    }
    
    /// Presents `VModal` using the item as data source for content.
    public func vModal<Item, HeaderLabel, Content>(
        item: Binding<Item?>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        modal: @escaping (Item) -> VModal<HeaderLabel, Content>
    ) -> some View
        where
            Item: Identifiable,
            HeaderLabel: View,
            Content: View
    {
        vModal(
            isPresented: .init(
                get: { item.wrappedValue != nil },
                set: { _ in item.wrappedValue = nil }
            ),
            onPresent: presentHandler,
            onDismiss: dismissHandler,
            modal: { modal(item.wrappedValue!) } // fatalError
        )
    }
}
