//
//  VToast.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/7/21.
//

import SwiftUI

// MARK: - V Toast
/// Message component that present text modally
///
/// Model can be passed as parameter
///
/// `vToast` modifier can be used on any view down the view hierarchy, as content overlay will always be centered on the screen
///
/// # Usage Example #
///
/// ```
/// @State var isPresented: Bool = false
///
/// var body: some View {
///     VSecondaryButton(
///         action: { isPresented = true },
///         title: "Present"
///     )
///         .vToast(isPresented: $isPresented, modal: {
///             VToast(
///                 type: .oneLine,
///                 title: "Lorem ipsum dolor sit amet"
///             )
///         })
/// }
/// ```
///
public struct VToast {
    // MARK: Properties
    fileprivate let model: VToastModel
    fileprivate let toastType: VToastType
    fileprivate let title: String
    
    // MARK: Initializers
    /// Initializes component with type and title
    public init(
        model: VToastModel = .init(),
        type toastType: VToastType,
        title: String
    ) {
        self.model = model
        self.toastType = toastType
        self.title = title
    }
}

// MARK: - Extension
extension View {
    /// Presents toast
    public func vToast(
        isPresented: Binding<Bool>,
        toast: @escaping () -> VToast
    ) -> some View {
        let toast = toast()
        
        return self
            .overlay(Group(content: {
                if isPresented.wrappedValue {
                    WindowOverlayView(
                        allowsHitTesting: false,
                        isPresented: isPresented,
                        content:
                            _VToast(
                                model: toast.model,
                                toastType: toast.toastType,
                                isPresented: isPresented,
                                title: toast.title
                            )
                    )
                        .allowsHitTesting(false)
                }
            }))
    }
}
