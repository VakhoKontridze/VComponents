//
//  PresentationHost.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 4/14/22.
//

import SwiftUI

// MARK: - Presentation Host
struct PresentationHost<Content>: UIViewControllerRepresentable where Content: View {
    // MARK: Properties
    private let id: String
    private let allowsHitTests: Bool
    private let isPresented: Binding<Bool>
    private let content: () -> Content
    
    @State private var wasInternallyDismissed: Bool = false
    
    // MARK: Initializers
    init(
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
    func makeUIViewController(context: Context) -> UIViewController {
        PresentationHostViewController(
            id: id,
            allowsHitTests: allowsHitTests
        )
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
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
}
