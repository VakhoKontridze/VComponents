//
//  View+VAlert.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI
import VCore

@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension View {
    /// Modal component that presents alert with actions and hosts content.
    ///
    /// Alert can have one, two, or many buttons.
    /// Two buttons are stacked horizontally, while more are stacked vertically.
    ///
    /// Optionally, content can be presented with methods that have `content` argument.
    ///
    ///     @State private var isPresented: Bool = false
    ///
    ///     var body: some View {
    ///         ZStack {
    ///             VPlainButton(
    ///                 action: { isPresented = true },
    ///                 title: "Present"
    ///             )
    ///             .vAlert(
    ///                 link: .window(linkID: "alert"),
    ///                 isPresented: $isPresented,
    ///                 title: "Lorem Ipsum",
    ///                 message: "Lorem ipsum dolor sit amet",
    ///                 actions: {
    ///                     VAlertButton(action: { print("Confirmed") }, title: "Confirm", role: .primary)
    ///                     VAlertButton(action: { print("Cancelled") }, title: "Cancel", role: .cancel)
    ///                 }
    ///             )
    ///         }
    ///         .frame(maxWidth: .infinity, maxHeight: .infinity) // For `overlay` configuration
    ///         .modalPresenterRoot(root: .window()) // Or declare in `App` on a `WindowScene`-level
    ///     }
    ///
    public func vAlert(
        link: ModalPresenterLink,
        appearance: VAlertAppearance = .init(),
        isPresented: Binding<Bool>,
        onPresent: (() -> Void)? = nil,
        onDismiss: (() -> Void)? = nil,
        title: String?,
        message: String?,
        @VAlertButtonBuilder actions buttons: @escaping () -> [any VAlertButtonProtocol]
    ) -> some View {
        self
            .modalPresenterLink(
                link: link,
                appearance: appearance.modalPresenterLinkAppearance,
                isPresented: isPresented,
                onPresent: onPresent,
                onDismiss: onDismiss
            ) {
                VAlert<Never>(
                    appearance: appearance,
                    isPresented: isPresented,
                    title: title,
                    message: message,
                    content: .empty,
                    buttons: buttons()
                )
            }
    }
    
    /// Modal component that presents alert with actions and hosts content.
    ///
    /// For additional info, refer to method with `Bool` presentation flag.
    public func vAlert<Content>(
        link: ModalPresenterLink,
        appearance: VAlertAppearance = .init(),
        isPresented: Binding<Bool>,
        onPresent: (() -> Void)? = nil,
        onDismiss: (() -> Void)? = nil,
        title: String?,
        message: String?,
        @ViewBuilder content: @escaping () -> Content,
        @VAlertButtonBuilder actions buttons: @escaping () -> [any VAlertButtonProtocol]
    ) -> some View
        where Content: View
    {
        self
            .modalPresenterLink(
                link: link,
                appearance: appearance.modalPresenterLinkAppearance,
                isPresented: isPresented,
                onPresent: onPresent,
                onDismiss: onDismiss
            ) {
                VAlert<Content>(
                    appearance: appearance,
                    isPresented: isPresented,
                    title: title,
                    message: message,
                    content: .content(content: content),
                    buttons: buttons()
                )
            }
    }
}

@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension View {
    /// Modal component that presents alert with actions and hosts content.
    ///
    /// For additional info, refer to method with `Bool` presentation flag.
    public func vAlert<Item>(
        link: ModalPresenterLink,
        appearance: @escaping (Item) -> VAlertAppearance = { _ in VAlertAppearance() },
        item: Binding<Item?>,
        onPresent: (() -> Void)? = nil,
        onDismiss: (() -> Void)? = nil,
        title: @escaping (Item) -> String?,
        message: @escaping (Item) -> String?,
        @VAlertButtonBuilder actions buttons: @escaping (Item) -> [any VAlertButtonProtocol]
    ) -> some View
        where Item: Equatable
    {
        let isPresented: Binding<Bool> = .init(
            get: { item.wrappedValue != nil },
            set: { if !$0 { item.wrappedValue = nil } }
        )

        return self
            .withLastNonNil(item.wrappedValue) { (view, item) in
                let appearance: VAlertAppearance = item.map(appearance) ?? VAlertAppearance()
                let title: String = item.flatMap(title) ?? ""
                let message: String = item.flatMap(message) ?? ""
                let buttons: [any VAlertButtonProtocol] = item.map(buttons) ?? []
                
                view
                    .modalPresenterLink(
                        link: link,
                        appearance: appearance.modalPresenterLinkAppearance,
                        isPresented: isPresented,
                        onPresent: onPresent,
                        onDismiss: onDismiss
                    ) {
                        VAlert<Never>(
                            appearance: appearance,
                            isPresented: isPresented,
                            title: title,
                            message: message,
                            content: VAlertContent.empty,
                            buttons: buttons
                        )
                    }
            }
    }
    
    /// Modal component that presents alert with actions and hosts content.
    ///
    /// For additional info, refer to method with `Bool` presentation flag.
    public func vAlert<Item, Content>(
        link: ModalPresenterLink,
        appearance: @escaping (Item) -> VAlertAppearance = { _ in VAlertAppearance() },
        item: Binding<Item?>,
        onPresent: (() -> Void)? = nil,
        onDismiss: (() -> Void)? = nil,
        title: @escaping (Item) -> String?,
        message: @escaping (Item) -> String?,
        @ViewBuilder content: @escaping (Item) -> Content,
        @VAlertButtonBuilder actions buttons: @escaping (Item) -> [any VAlertButtonProtocol]
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
                let appearance: VAlertAppearance = item.map(appearance) ?? VAlertAppearance()
                let title: String = item.flatMap(title) ?? ""
                let message: String = item.flatMap(message) ?? ""
                let content: VAlertContent = item.map { item in .content(content: { content(item) }) } ?? .empty
                let buttons: [any VAlertButtonProtocol] = item.map(buttons) ?? []
                
                view
                    .modalPresenterLink(
                        link: link,
                        appearance: appearance.modalPresenterLinkAppearance,
                        isPresented: isPresented,
                        onPresent: onPresent,
                        onDismiss: onDismiss
                    ) {
                        VAlert(
                            appearance: appearance,
                            isPresented: isPresented,
                            title: title,
                            message: message,
                            content: content,
                            buttons: buttons
                        )
                    }
            }
    }
}

@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension View {
    /// Modal component that presents alert with actions and hosts content.
    ///
    /// For additional info, refer to method with `Bool` presentation flag.
    public func vAlert<E>(
        link: ModalPresenterLink,
        appearance: @escaping (E) -> VAlertAppearance = { _ in VAlertAppearance() },
        isPresented: Binding<Bool>,
        error: E?,
        onPresent: (() -> Void)? = nil,
        onDismiss: (() -> Void)? = nil,
        title: @escaping (E) -> String?,
        message: @escaping (E) -> String?,
        @VAlertButtonBuilder actions buttons: @escaping (E) -> [any VAlertButtonProtocol]
    ) -> some View
        where E: Error & Equatable
    {
        let isPresented: Binding<Bool> = .init(
            get: { isPresented.wrappedValue && error != nil },
            set: { if !$0 { isPresented.wrappedValue = false } }
        )

        return self
            .withLastNonNil(error) { (view, error) in
                let appearance: VAlertAppearance = error.map(appearance) ?? VAlertAppearance()
                let title: String = error.flatMap(title) ?? ""
                let message: String = error.flatMap(message) ?? ""
                let buttons: [any VAlertButtonProtocol] = error.map(buttons) ?? []
                
                view
                    .modalPresenterLink(
                        link: link,
                        appearance: appearance.modalPresenterLinkAppearance,
                        isPresented: isPresented,
                        onPresent: onPresent,
                        onDismiss: onDismiss
                    ) {
                        VAlert<Never>(
                            appearance: appearance,
                            isPresented: isPresented,
                            title: title,
                            message: message,
                            content: VAlertContent.empty,
                            buttons: buttons
                        )
                    }
            }
    }
    
    /// Modal component that presents alert with actions and hosts content.
    ///
    /// For additional info, refer to method with `Bool` presentation flag.
    public func vAlert<E, Content>(
        link: ModalPresenterLink,
        appearance: @escaping (E) -> VAlertAppearance = { _ in VAlertAppearance() },
        isPresented: Binding<Bool>,
        error: E?,
        onPresent: (() -> Void)? = nil,
        onDismiss: (() -> Void)? = nil,
        title: @escaping (E) -> String?,
        message: @escaping (E) -> String?,
        @ViewBuilder content: @escaping (E) -> Content,
        @VAlertButtonBuilder actions buttons: @escaping (E) -> [VAlertButton]
    ) -> some View
        where
            E: Error & Equatable,
            Content: View
    {
        let isPresented: Binding<Bool> = .init(
            get: { isPresented.wrappedValue && error != nil },
            set: { if !$0 { isPresented.wrappedValue = false } }
        )

        return self
            .withLastNonNil(error) { (view, error) in
                let appearance: VAlertAppearance = error.map(appearance) ?? VAlertAppearance()
                let title: String = error.flatMap(title) ?? ""
                let message: String = error.flatMap(message) ?? ""
                let content: VAlertContent = error.map { error in .content(content: { content(error) }) } ?? .empty
                let buttons: [any VAlertButtonProtocol] = error.map(buttons) ?? []
                
                view
                    .modalPresenterLink(
                        link: link,
                        appearance: appearance.modalPresenterLinkAppearance,
                        isPresented: isPresented,
                        onPresent: onPresent,
                        onDismiss: onDismiss
                    ) {
                        VAlert(
                            appearance: appearance,
                            isPresented: isPresented,
                            title: title,
                            message: message,
                            content: content,
                            buttons: buttons
                        )
                    }
            }
    }
}
