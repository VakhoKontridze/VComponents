//
//  PresentationHostExtension.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 06.03.23.
//

import SwiftUI

// MARK: - Extension
extension View {
    /// Injects an `UIHostingController` in view hierarchy that can be used to present modals in `UIKit` style.
    ///
    ///     extension View {
    ///         public func someModal(
    ///             id: String,
    ///             isPresented: Binding<Bool>,
    ///             @ViewBuilder content: @escaping () -> some View
    ///         ) -> some View {
    ///             self
    ///                 .presentationHost(
    ///                     id: id,
    ///                     isPresented: isPresented,
    ///                     content: {
    ///                         SomeModal(
    ///                             content: content
    ///                         )
    ///                     }
    ///                 )
    ///         }
    ///     }
    ///
    ///     struct SomeModal<Content>: View where Content: View {
    ///         @Environment(\.presentationHostPresentationMode) private var presentationMode
    ///         private let content: () -> Content
    ///
    ///         @State private var isInternallyPresented: Bool = false // Cane be used for animations
    ///
    ///         init(content: @escaping () -> Content) {
    ///             self.content = content
    ///         }
    ///
    ///         var body: some View {
    ///             content() // UI, customization, and animations go here...
    ///
    ///                 .onAppear(perform: animateIn)
    ///                 .onTapGesture(perform: animateOut)
    ///                 .onChange(
    ///                     of: presentationMode.isExternallyDismissed,
    ///                     perform: { if $0 && isInternallyPresented { animateOutFromExternalDismiss() } }
    ///                 )
    ///         }
    ///
    ///         private func animateIn() {
    ///             withBasicAnimation(
    ///                 .init(curve: .easeInOut, duration: 0.3),
    ///                 body: { isInternallyPresented = true },
    ///                 completion: nil
    ///             )
    ///         }
    ///
    ///         private func animateOut() {
    ///             withBasicAnimation(
    ///                 .init(curve: .easeInOut, duration: 0.3),
    ///                 body: { isInternallyPresented = false },
    ///                 completion: presentationMode.dismiss
    ///             )
    ///         }
    ///
    ///         private func animateOutFromExternalDismiss() {
    ///             withBasicAnimation(
    ///                 .init(curve: .easeInOut, duration: 0.3),
    ///                 body: { isInternallyPresented = false },
    ///                 completion: presentationMode.externalDismissCompletion
    ///             )
    ///         }
    ///     }
    ///
    public func presentationHost<Content>(
        id: String,
        allowsHitTests: Bool = true,
        isPresented: Binding<Bool>,
        content: @escaping () -> Content
    ) -> some View
        where Content: View
    {
        self
            .onDisappear(perform: { PresentationHostViewController.forceDismiss(id: id) })
            .background(PresentationHost(
                id: id,
                allowsHitTests: allowsHitTests,
                isPresented: isPresented,
                content: content
            ))
    }
    
    func presentationHost<Item ,Content>(
        id: String,
        allowsHitTests: Bool = true,
        item: Binding<Item?>,
        content: @escaping () -> Content
    ) -> some View
        where Content: View
    {
        self
            .presentationHost(
                id: id,
                allowsHitTests: allowsHitTests,
                isPresented: .init(
                    get: { item.wrappedValue != nil },
                    set: { if !$0 { item.wrappedValue = nil } }
                ),
                content: content
            )
    }
    
    func presentationHost<T ,Content>(
        id: String,
        allowsHitTests: Bool = true,
        isPresented: Binding<Bool>,
        presenting data: T?,
        content: @escaping () -> Content
    ) -> some View
        where Content: View
    {
        self
            .presentationHost(
                id: id,
                allowsHitTests: allowsHitTests,
                isPresented: .init(
                    get: { isPresented.wrappedValue && data != nil },
                    set: { if !$0 { isPresented.wrappedValue = false } }
                ),
                content: content
            )
    }
    
    func presentationHost<E ,Content>(
        id: String,
        allowsHitTests: Bool = true,
        isPresented: Binding<Bool>,
        error: E?,
        content: @escaping () -> Content
    ) -> some View
        where Content: View
    {
        self
            .presentationHost(
                id: id,
                allowsHitTests: allowsHitTests,
                isPresented: .init(
                    get: { isPresented.wrappedValue && error != nil },
                    set: { if !$0 { isPresented.wrappedValue = false } }
                ),
                content: content
            )
    }
}
