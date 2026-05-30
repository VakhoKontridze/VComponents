//
//  View+VToast.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/7/21.
//

public import SwiftUI
public import VCore

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
    ///         ZStack {
    ///             VPlainButton(
    ///                 action: { isPresented = true },
    ///                 title: "Present"
    ///             )
    ///             .vToast(
    ///                 link: .window(rootID: "notifications", linkID: "toast"),
    ///                 isPresented: $isPresented,
    ///                 text: "Lorem ipsum dolor sit amet"
    ///             )
    ///         }
    ///         .frame(maxWidth: .infinity, maxHeight: .infinity) // For `overlay` configuration
    ///         .modalPresenterRoot( // Or declare in `App` on a `WindowScene`-level
    ///             root: .window(rootID: "notifications"),
    ///             appearance: {
    ///                 var appearance: ModalPresenterRootAppearance = .init()
    ///                 appearance.dimmingViewColor = Color.clear
    ///                 appearance.dimmingViewTapAction = .passTapsThrough
    ///                 return appearance
    ///             }()
    ///         )
    ///     }
    ///
    /// Highlights can be applied using `info`, `success`, `warning`, and `error` instances of `VToastAppearance`.
    public func vToast(
        link: ModalPresenterLink,
        appearance: VToastAppearance = .init(),
        isPresented: Binding<Bool>,
        onPresent: (() -> Void)? = nil,
        onDismiss: (() -> Void)? = nil,
        text: String
    ) -> some View {
        self
            .modalPresenterLink(
                link: link,
                appearance: appearance.modalPresenterLinkAppearance,
                isPresented: isPresented,
                onPresent: onPresent,
                onDismiss: onDismiss
            ) {
                VToast(
                    appearance: appearance,
                    isPresented: isPresented,
                    text: text
                )
            }
    }
}

@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension View {
    /// Modal component that presents toast.
    ///
    /// For additional info, refer to method with `Bool` presentation flag.
    public func vToast<Item>(
        link: ModalPresenterLink,
        appearance: @escaping (Item) -> VToastAppearance = { _ in VToastAppearance() },
        item: Binding<Item?>,
        onPresent: (() -> Void)? = nil,
        onDismiss: (() -> Void)? = nil,
        text: @escaping (Item) -> String
    ) -> some View
        where Item: Identifiable
    {
        let isPresented: Binding<Bool> = .init(
            get: { item.wrappedValue != nil },
            set: { if !$0 { item.wrappedValue = nil } }
        )

        return self
            .withLastNonNil(item.wrappedValue) { (view, item) in
                let appearance: VToastAppearance = item.map(appearance) ?? VToastAppearance()
                let text: String = item.flatMap(text) ?? ""
                
                view
                    .modalPresenterLink(
                        link: link,
                        appearance: appearance.modalPresenterLinkAppearance,
                        isPresented: isPresented,
                        onPresent: onPresent,
                        onDismiss: onDismiss
                    ) {
                        VToast(
                            appearance: appearance,
                            isPresented: isPresented,
                            text: text
                        )
                    }
            }
    }
}

@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension View {
    /// Modal component that presents toast.
    ///
    /// For additional info, refer to method with `Bool` presentation flag.
    public func vToast<E>(
        link: ModalPresenterLink,
        appearance: @escaping (E) -> VToastAppearance = { _ in VToastAppearance() },
        isPresented: Binding<Bool>,
        error: E?,
        onPresent: (() -> Void)? = nil,
        onDismiss: (() -> Void)? = nil,
        text: @escaping (E) -> String
    ) -> some View
        where E: Error & Equatable
    {
        let isPresented: Binding<Bool> = .init(
            get: { isPresented.wrappedValue && error != nil },
            set: { if !$0 { isPresented.wrappedValue = false } }
        )

        return self
            .withLastNonNil(error) { (view, error) in
                let appearance: VToastAppearance = error.map(appearance) ?? VToastAppearance()
                let text: String = error.flatMap(text) ?? ""
                
                view
                    .modalPresenterLink(
                        link: link,
                        appearance: appearance.modalPresenterLinkAppearance,
                        isPresented: isPresented,
                        onPresent: onPresent,
                        onDismiss: onDismiss
                    ) {
                        VToast(
                            appearance: appearance,
                            isPresented: isPresented,
                            text: text
                        )
                    }
            }
    }
}
