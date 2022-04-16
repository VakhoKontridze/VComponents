//
//  PresentationHost.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 4/14/22.
//

import SwiftUI

// MARK: - Presentation Host
/// Presentation Host that allows `SwiftUI` `View` to present another `View` modally in `UIKit` style.
///
/// `View` works by inserting an `UIViewController` in view hierarchy and using it as a presentation host.
/// `PresentationHost` presents content via `UIHostingController` embedded inside `PresentationHostViewController`.
///
/// When `isPresented` is set to `true` from code, and content is not yet presented, `PresentationHost` passes content to view hierarchy.
/// After this appear animations can occur.
///
/// When `dismiss` must be called from presented modal after dismiss animations have finished, `PresentationHost` will remove content from view hierarchy.
///
/// When `isPresented` is set to `false` from code, `PresentationHost` triggers external dismiss via `PresentationHostPresentationMode`.
/// This allows content to perform dismiss animations before being removed from view hierarchy.
/// For additional documentation, refer to `PresentationHostPresentationMode`.
///
/// Usage Example:
///
///     extension View {
///         public func someModal<Content>(
///             isPresented: Binding<Bool>,
///             someModal: @escaping () -> SomeModal<Content>
///         ) -> some View
///             where Content: View
///         {
///             self
///                 .background(PresentationHost(
///                     isPresented: isPresented,
///                     content: {
///                         _SomeModal(
///                             isPresented: isPresented,
///                             content: someModal().content
///                         )
///                     }
///                 ))
///         }
///     }
///
///     public struct SomeModal<Content> where Content: View {
///         public let content: () -> Content
///     }
///
///     struct _SomeModal<Content>: View where Content: View {
///         @Environment(\.presentationHostPresentationMode) private var presentationMode
///         private let content: () -> Content
///
///         init(content: @escaping () -> Content) {
///             self.content = content
///         }
///
///         var body: some View {
///             content() // UI, customization, and frame-based animations go here...
///
///                 .onAppear(perform: animateIn)
///                 .onTapGesture(perform: animateOut)
///                 .onChange(
///                     of: presentationMode.isExternallyDismissed,
///                     perform: { if $0 { animateOutFromExternalDismiss() } }
///                  )
///         }
///
///         private func animateIn() {
///             // Animate UI in with 0.5s duration...
///         }
///
///         private func animateOut() {
///             // Animate UI out with 0.5s duration...
///
///             DispatchQueue.main.asyncAfter(
///                 deadline: .now() + 0.5,
///                 execute: presentationMode.dismiss
///             )
///         }
///
///         private func animateOutFromExternalDismiss() {
///             // Animate UI out with 0.5s duration...
///
///             DispatchQueue.main.asyncAfter(
///                 deadline: .now() + 0.5,
///                 execute: presentationMode.externalDismissCompletion
///             )
///         }
///     }
///
public struct PresentationHost<Content>: UIViewControllerRepresentable where Content: View {
    // MARK: Properties
    private let isPresented: Binding<Bool>
    private let content: () -> Content
    
    @State private var wasInternallyDismissed: Bool = false
    
    /// Type of represented `UIViewController`.
    public typealias PresentationHostViewControllerType = PresentationHostViewController<AnyView>
    
    // MARK: Initializers
    /// Initializes `PresentationHost` with condition and content.
    public init(
        isPresented: Binding<Bool>,
        content: @escaping () -> Content
    ) {
        self.isPresented = isPresented
        self.content = content
    }
    
    // MARK: Representable
    public func makeUIViewController(context: Context) -> PresentationHostViewControllerType {
        .init()
    }

    public func updateUIViewController(_ uiViewController: PresentationHostViewControllerType, context: Context) {
        let content: AnyView = .init(
            content()
                .presentationHostPresentationMode(.init(
                    dismiss: {
                        wasInternallyDismissed = true
                        
                        isPresented.wrappedValue = false
                        uiViewController.dismissHostedView()
                        
                        DispatchQueue.main.async(execute: { wasInternallyDismissed = false })
                    },
                    
                    isExternallyDismissed:
                        uiViewController.presentedViewController is PresentationHostViewControllerType.HostingViewControllerType &&
                        !isPresented.wrappedValue &&
                        !wasInternallyDismissed
                    ,
                    
                    externalDismissCompletion: uiViewController.dismissHostedView
                ))
        )
        
        if
            isPresented.wrappedValue,
            uiViewController.presentedViewController == nil
        {
            uiViewController.presentHostedView(content)
        }
        
        uiViewController.updateHostedView(with: content)
    }
}
