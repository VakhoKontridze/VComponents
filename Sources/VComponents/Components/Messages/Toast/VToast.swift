//
//  VToast.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/7/21.
//

import SwiftUI

// MARK: - V Toast
/// Message component that present text modally.
///
/// Model can be passed as parameter.
///
/// `vToast` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
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
///             .vToast(isPresented: $isPresented, toast: {
///                 VToast(title: "Lorem ipsum dolor sit amet")
///             })
///     }
///
public struct VToast {
    // MARK: Properties
    fileprivate let model: VToastModel
    fileprivate let toastType: VToastType
    fileprivate let title: String
    
    // MARK: Initializers
    /// Initializes component with type and title.
    public init(
        model: VToastModel = .init(),
        type toastType: VToastType = .singleLine,
        title: String
    ) {
        self.model = model
        self.toastType = toastType
        self.title = title
    }
}

// MARK: - Extension
extension View {
    /// Presents `VToast` when boolean is `true`.
    public func vToast(
        isPresented: Binding<Bool>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        toast: @escaping () -> VToast
    ) -> some View {
        let toast = toast()
        
        return self
            .background(PresentationHost(
                isPresented: isPresented,
                allowsHitTests: false,
                content: {
                    _VToast(
                        model: toast.model,
                        toastType: toast.toastType,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        title: toast.title
                    )
                }
            ))
    }
    
    /// Presents `VToast` using the item as data source for content.
    @ViewBuilder public func vToast<Item>(
        item: Binding<Item?>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        toast: @escaping (Item) -> VToast
    ) -> some View
        where Item: Identifiable
    {
        switch item.wrappedValue {
        case nil:
            self
            
        case let _item?:
            vToast(
                isPresented: .init(
                    get: { true },
                    set: { _ in item.wrappedValue = nil }
                ),
                onPresent: presentHandler,
                onDismiss: dismissHandler,
                toast: { toast(_item) }
            )
        }
    }
}
