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
/// It works by embedding an `UIHostingController` in view hierarchy and using it as a presentation host.
///
///     extension View {
///         public func someModal(
///             id: String,
///             isPresented: Binding<Bool>,
///             @ViewBuilder content: @escaping () -> some View
///         ) -> some View {
///             self
///                 .onDisappear(perform: { PresentationHost.forceDismiss(id: id) })
///                 .background(PresentationHost(
///                     id: id,
///                     isPresented: isPresented,
///                     content: {
///                         SomeModal(
///                             content: content
///                         )
///                     }
///                 ))
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
///                  )
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
public struct PresentationHost<Content>: UIViewControllerRepresentable where Content: View {
    // MARK: Properties
    private let id: String
    private let allowsHitTests: Bool
    private let isPresented: Binding<Bool>
    private let content: () -> Content
    
    @State private var wasInternallyDismissed: Bool = false
    
    // MARK: Initializers
    /// Initializes `PresentationHost` with condition and content.
    public init(
        id: String,
        allowsHitTests: Bool = true,
        isPresented: Binding<Bool>,
        content: @escaping () -> Content
    ) {
        self.id = id
        self.allowsHitTests = allowsHitTests
        self.isPresented = isPresented
        self.content = content
    }
    
    // MARK: Representable
    public func makeUIViewController(context: Context) -> UIViewController {
        PresentationHostViewController(
            id: id,
            allowsHitTests: allowsHitTests
        )
    }

    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        guard let uiViewController = uiViewController as? PresentationHostViewController else { fatalError() }
        
        let isExternallyDismissed: Bool =
            uiViewController.isPresentingView &&
            !isPresented.wrappedValue &&
            !wasInternallyDismissed

        let dismissHandler: () -> Void = {
            wasInternallyDismissed = true
            defer { DispatchQueue.main.async(execute: { wasInternallyDismissed = false }) }

            isPresented.wrappedValue = false
            uiViewController.dismissHostedView()
        }

        let content: AnyView = .init(
            content()
                .presentationHostPresentationMode(.init(
                    id: id,
                    dismiss: dismissHandler,
                    isExternallyDismissed: isExternallyDismissed,
                    externalDismissCompletion: uiViewController.dismissHostedView
                ))
        )

        if
            isPresented.wrappedValue,
            !uiViewController.isPresentingView
        {
            uiViewController.presentHostedView(content)
        }

        uiViewController.updateHostedView(with: content)
    }
    
    // MARK: Force Dismiss
    /// Forcefully dismisses presented `View` from presenting `View`.
    public static func forceDismiss(id: String)
        where Content == Never
    {
        PresentationHostViewController.forceDismiss(id: id)
    }
}
