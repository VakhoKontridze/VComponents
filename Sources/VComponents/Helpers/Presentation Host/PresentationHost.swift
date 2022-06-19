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
/// If presenting view dissapears, either by navigation, or by `ViewBuilder` render (such as `if` block evaluating to `false`),
/// modal must be removed from view hierarchy. To ensure proper removal, call `PresentationHost.forceDismiss(in:)`.
/// Currently, `PresentationHost` uses type of presenting view as an identifier for removing expired models.
/// `forceDismiss` ignores the animations of modal, and force removes `View` from the hierarchy.
/// Since presenting `View` may have disspeared, state of the modal can no longer be updated, and animations cannot occur.
///
/// Presentation Host caches data when `item: Binding<Item?>`, `presenting data: T?`, and `error: E?` extensions are used.
/// Yype of presenting `View` is used as a key in a cache . This however, has one limitation.
/// If two modals are active at the same time, who are launched from the same `View` type (such as `SwiftUI.Button`), caching will fail.
///
///     extension View {
///         public func someModal(
///             isPresented: Binding<Bool>,
///             @ViewBuilder content: @escaping () -> some View
///         ) -> some View {
///             self
///                 .onDisappear(perform: { PresentationHost.forceDismiss(in: self) })
///                 .background(PresentationHost(
///                     in: self,
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
    private let presentingViewType: String
    private let isPresented: Binding<Bool>
    private let allowsHitTests: Bool
    private let content: () -> Content
    
    @State private var wasInternallyDismissed: Bool = false
    
    // MARK: Initializers
    /// Initializes `PresentationHost` with condition and content.
    public init(
        in presentingView: some View,
        isPresented: Binding<Bool>,
        allowsHitTests: Bool = true,
        content: @escaping () -> Content
    ) {
        self.presentingViewType = SwiftUIViewTypeDescriber.describe(presentingView)
        self.isPresented = isPresented
        self.allowsHitTests = allowsHitTests
        self.content = content
    }
    
    // MARK: Representable
    public func makeUIViewController(context: Context) -> PresentationHostViewController {
        .init(
            presentingViewType: presentingViewType,
            allowsHitTests: allowsHitTests
        )
    }

    public func updateUIViewController(_ uiViewController: PresentationHostViewController, context: Context) {
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
                    instanceID: uiViewController.instanceID,
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
    /// Forcefully dismisses presented view from presenter.
    public static func forceDismiss(
        in presentingView: some View
    )
        where Content == Never
    {
        PresentationHostViewController.forceDismiss(in: presentingView)
    }
}
