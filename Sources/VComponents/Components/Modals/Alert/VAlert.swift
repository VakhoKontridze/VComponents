//
//  VAlert.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI

// MARK: - V Alert
/// Modal component that presents alert when condition is true.
///
/// Model, title, description, and content can be passed as parameters.
///
/// Alert can have one, two, or many buttons. Two buttons are stacked horizontally, while many buttons are stacked vertically.
///
/// `vAlert` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
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
///             .vAlert(isPresented: $isPresented, alert: {
///                 VAlert(
///                     title: "Lorem ipsum",
///                     description: "Lorem ipsum dolor sit amet",
///                     actions: [
///                         .primary(action: { print("Confirmed") }, title: "Confirm"),
///                         .cancel(action: { print("Cancelled") })
///                     ]
///                 )
///         })
///     }
///
public struct VAlert<Content>
    where Content: View
{
    // MARK: Properties
    fileprivate let model: VAlertModel
    
    fileprivate let title: String?
    fileprivate let description: String?
    fileprivate let content: (() -> Content)?
    fileprivate let buttons: [VAlertButton]
    
    // MARK: Initializers
    /// Initializes component with buttons, title, description, and content.
    public init(
        model: VAlertModel = .init(),
        title: String?,
        description: String?,
        @ViewBuilder content: @escaping () -> Content,
        actions buttons: [VAlertButton]
    ) {
        self.model = model
        self.title = title
        self.description = description
        self.content = content
        self.buttons = buttons
    }
    
    /// Initializes component with buttons, title, and description.
    public init(
        model: VAlertModel = .init(),
        title: String?,
        description: String?,
        actions buttons: [VAlertButton]
    )
        where Content == Never
    {
        self.model = model
        self.title = title
        self.description = description
        self.content = nil
        self.buttons = buttons
    }
}

// MARK: - Extension
extension View {
    /// Presents `VAlert` when boolean is true.
    public func vAlert<Content>(
        isPresented: Binding<Bool>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        alert: @escaping () -> VAlert<Content>
    ) -> some View
        where Content: View
    {
        let alert = alert()
        
        return self
            .background(PresentationHost(
                isPresented: isPresented,
                content: {
                    _VAlert(
                        model: alert.model,
                        presentHandler: presentHandler,
                        dismissHandler: dismissHandler,
                        title: alert.title,
                        description: alert.description,
                        content: alert.content,
                        buttons: alert.buttons
                    )
                }
            ))
    }
    
    /// Presents `VAlert` using the item as data source for content.
    @ViewBuilder public func vAlert<Item, Content>(
        item: Binding<Item?>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        alert: @escaping (Item) -> VAlert<Content>
    ) -> some View
        where
            Item: Identifiable,
            Content: View
    {
        switch item.wrappedValue {
        case nil:
            self
            
        case let _item?:
            self
                .vAlert(
                    isPresented: .init(
                        get: { true },
                        set: { _ in item.wrappedValue = nil }
                    ),
                    onPresent: presentHandler,
                    onDismiss: dismissHandler,
                    alert: { alert(_item) }
                )
        }
    }
    
    /// Presents `VAlert` when boolean is true with an `Error`.
    public func vAlert<E, Content>(
        isPresented: Binding<Bool>,
        error: E?,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        alert: @escaping (E?) -> VAlert<Content>
    ) -> some View
        where
            E: Error,
            Content: View
    {
        vAlert(
            isPresented: isPresented,
            onPresent: presentHandler,
            onDismiss: dismissHandler,
            alert: { alert(error) }
        )
    }
}
