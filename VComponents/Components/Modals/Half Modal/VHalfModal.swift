//
//  VHalfModal.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/21/21.
//

import SwiftUI

// MARK: - V Half Modal
/// Modal component that draws a background, hosts pull-up content on the bottom of the screen, and is present when condition is true.
///
/// Model and header can be passed as parameters.
///
/// If invalid height parameter are passed during init, layout would invalidate itself, and refuse to draw.
///
/// `vHalfModal` modifier can be used on any view down the view hierarchy, as content overlay will always be centered on the screen.
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
///             .vHalfModal(isPresented: $isPresented, halfModal: {
///                 VHalfModal(
///                     headerTitle: "Lorem ipsum dolor sit amet",
///                     content: { ColorBook.accent }
///                 )
///             })
///     }
///
public struct VHalfModal<HeaderLabel, Content>
    where
        HeaderLabel: View,
        Content: View
{
    // MARK: Properties
    fileprivate let model: VHalfModalModel
    
    fileprivate let headerLabel: VHalfModalHeaderLabel<HeaderLabel>
    fileprivate let content: () -> Content
    
    // MARK: Initializers
    /// Initializes component content.
    public init(
        model: VHalfModalModel = .init(),
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
        model: VHalfModalModel = .init(),
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
        model: VHalfModalModel = .init(),
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
    /// Presents `VHalfModal` when boolean is true.
    public func vHalfModal<HeaderLabel, Content>(
        isPresented: Binding<Bool>,
        onDismiss dismissHandler: (() -> Void)? = nil,
        halfModal: @escaping () -> VHalfModal<HeaderLabel, Content>
    ) -> some View
        where
            HeaderLabel: View,
            Content: View
    {
        let halfModal = halfModal()
        
        return self
            .background(PresentationHost(
                isPresented: isPresented,
                content: {
                    _VHalfModal(
                        model: halfModal.model,
                        onDismiss: dismissHandler,
                        headerLabel: halfModal.headerLabel,
                        content: halfModal.content
                    )
                }
            ))
    }
    
    /// Presents `VHalfModal` using the item as data source for content.
    @ViewBuilder public func vHalfModal<Item, HeaderLabel, Content>(
        item: Binding<Item?>,
        onDismiss dismissHandler: (() -> Void)? = nil,
        halfModal: @escaping (Item) -> VHalfModal<HeaderLabel, Content>
    ) -> some View
        where
            Item: Identifiable,
            HeaderLabel: View,
            Content: View
    {
        switch item.wrappedValue {
        case nil:
            self
            
        case let _item?:
            self
                .vHalfModal(
                    isPresented: .init(
                        get: { true },
                        set: { _ in item.wrappedValue = nil }
                    ),
                    onDismiss: dismissHandler,
                    halfModal: { halfModal(_item) }
                )
        }
    }
}
