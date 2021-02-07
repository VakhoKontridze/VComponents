//
//  VToast.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/7/21.
//

import SwiftUI

// MARK:- V Toast
public struct VToast {
    // MARK: Properties
    fileprivate let model: VToastModel
    fileprivate let toastType: VToastType
    fileprivate let title: String
    
    // MARK: Initializers
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

// MARK:- Extension
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
                    UIKitRepresentable(
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
