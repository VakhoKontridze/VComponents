//
//  VToastExtension.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/7/21.
//

import SwiftUI

// MARK: - Bool
extension View {
    /// Presents `VToast` when boolean is `true`.
    ///
    /// Modal component that presents toast, and hosts content.
    ///
    /// Model, type, and present and dismiss handlers can be passed as parameters.
    ///
    /// `vToast` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
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
    ///             .vToast(
    ///                 isPresented: $isPresented,
    ///                 title: "Lorem ipsum dolor sit amet"
    ///             )
    ///     }
    ///
    public func vToast(
        model: VToastModel = .init(),
        type toastType: VToastType = .singleLine,
        isPresented: Binding<Bool>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        title: String
    ) -> some View {
        self
            .background(PresentationHost(
                isPresented: isPresented,
                allowsHitTests: false,
                content: {
                    VToast(
                        model: model,
                        type: toastType,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        title: title
                    )
                }
            ))
    }
}

// MARK: - Item
extension View {
    /// Presents `VToast` using the item as data source for content.
    ///
    /// Modal component that presents toast, and hosts content.
    ///
    /// Model, type, and present and dismiss handlers can be passed as parameters.
    ///
    /// `vToast` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
    ///
    /// Usage Example:
    ///
    ///     struct ToastItem: Identifiable {
    ///         let id: UUID = .init()
    ///     }
    ///
    ///     @State var toastItem: ToastItem?
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { toastItem = .init() },
    ///             title: "Present"
    ///         )
    ///             .vToast(
    ///                 item: $toastItem,
    ///                 title: { item in "Lorem ipsum dolor sit amet" }
    ///             )
    ///     }
    ///
    public func vToast<Item>(
        model: VToastModel = .init(),
        type toastType: VToastType = .singleLine,
        item: Binding<Item?>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        title: @escaping (Item) -> String
    ) -> some View
        where Item: Identifiable
    {
        self
            .background(PresentationHost(
                isPresented: .init(
                    get: { item.wrappedValue != nil },
                    set: { if !$0 { item.wrappedValue = nil } }
                ),
                allowsHitTests: false,
                content: { () -> VToast in
                    let item = item.wrappedValue! // fatalError
                    
                    return .init(
                        model: model,
                        type: toastType,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        title: title(item)
                    )
                }
            ))
    }
}

// MARK: - Presenting Data
extension View {
    /// Presents `VToast` when boolean is `true` using data to produce content.
    ///
    /// Modal component that presents toast, and hosts content.
    ///
    /// Model, type, and present and dismiss handlers can be passed as parameters.
    ///
    /// `vToast` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
    ///
    /// For the toast to appear, both `isPresented` must be true and `data` must not be nil.
    /// The `data` should not change after the presentation occurs.
    /// Any changes that you make after the presentation occurs are ignored.
    ///
    /// Usage Example:
    ///
    ///     struct ToastData {}
    ///
    ///     @State var isPresented: Bool = false
    ///
    ///     @State var toastData: ToastData?
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { isPresented = true; toastData = .init() },
    ///             title: "Present"
    ///         )
    ///             .vToast(
    ///                 isPresented: $isPresented,
    ///                 presenting: toastData,
    ///                 title: { data in "Lorem ipsum dolor sit amet" }
    ///             )
    ///     }
    ///
    public func vToast<T>(
        model: VToastModel = .init(),
        type toastType: VToastType = .singleLine,
        isPresented: Binding<Bool>,
        presenting data: T?,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        title: @escaping (T) -> String
    ) -> some View {
        self
            .background(PresentationHost(
                isPresented: .init(
                    get: { isPresented.wrappedValue && data != nil },
                    set: { if !$0 { isPresented.wrappedValue = false } }
                ),
                allowsHitTests: false,
                content: { () -> VToast in
                    let data = data! // fatalError
                    
                    return .init(
                        model: model,
                        type: toastType,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        title: title(data)
                    )
                }
            ))
    }
}

// MARK: - Error
extension View {
    /// Presents `VToast` when boolean is `true` using `Error`
    ///
    /// Modal component that presents toast, and hosts content.
    ///
    /// Model, type, and present and dismiss handlers can be passed as parameters.
    ///
    /// `vToast` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
    ///
    /// For the toast to appear, both `isPresented` must be true and `error` must not be nil.
    /// The `error` should not change after the presentation occurs.
    /// Any changes that you make after the presentation occurs are ignored.
    ///
    /// Usage Example:
    ///
    ///     @State var isPresented: Bool = false
    ///
    ///     @State var toastError: Error?
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { isPresented = true; toastError = SomeError() },
    ///             title: "Present"
    ///         )
    ///             .vToast(
    ///                 isPresented: $isPresented,
    ///                 error: toastError,
    ///                 title: { error in "Lorem ipsum dolor sit amet" }
    ///             )
    ///     }
    ///
    public func vToast<E>(
        model: VToastModel = .init(),
        type toastType: VToastType = .singleLine,
        isPresented: Binding<Bool>,
        error: E?,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        title: @escaping (E) -> String
    ) -> some View
        where E: Error
    {
        self
            .background(PresentationHost(
                isPresented: .init(
                    get: { isPresented.wrappedValue && error != nil },
                    set: { if !$0 { isPresented.wrappedValue = false } }
                ),
                allowsHitTests: false,
                content: { () -> VToast in
                    let error = error! // fatalError
                    
                    return .init(
                        model: model,
                        type: toastType,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        title: title(error)
                    )
                }
            ))
    }
}
