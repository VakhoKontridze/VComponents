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
///
///     extension View {
///         public func someModal<Content>(
///             isPresented: Binding<Bool>,
///             someModal: @escaping () -> SomeModal<Content>
///         ) -> some View
///             where Content: View
///         {
///             self
///                 .onDisappear(perform: { PresentationHost.forceDismiss(in: self) })
///                 .background(PresentationHost(
///                     in: self,
///                     isPresented: isPresented,
///                     content: {
///                         _SomeModal(
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
    public init<PresentingView>(
        in presentingView: PresentingView,
        isPresented: Binding<Bool>,
        allowsHitTests: Bool = true,
        content: @escaping () -> Content
    )
        where PresentingView: View
    {
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
    public static func forceDismiss<PresentingView>(
        in presentingView: PresentingView
    )
        where
            Content == Never,
            PresentingView: View
    {
        PresentationHostViewController.forceDismiss(in: presentingView)
    }
}
