//
//  WindowOverlayView.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/21/21.
//

import SwiftUI

// MARK: - Window Overlay View
struct WindowOverlayView<Content>: UIViewControllerRepresentable where Content: View {
    // MARK: Properties
    private let allowsHitTesting: Bool
    @Binding private var isPresented: Bool
    private let content: Content

    // MARK: Initializers
    init(
        allowsHitTesting: Bool = true,
        isPresented: Binding<Bool>,
        content: Content
    ) {
        self.allowsHitTesting = allowsHitTesting
        self._isPresented = isPresented
        self.content = content
    }

    // MARK: Representabe
    func makeUIViewController(context: Context) -> WindowOverlayViewController<Content> {
        .init(allowsHitTesting: allowsHitTesting, content: content)
    }

    func updateUIViewController(_ uiViewController: WindowOverlayViewController<Content>, context: Context) {
        switch isPresented {
        case false: uiViewController.dismiss()
        case true: uiViewController.update(with: content)
        }
    }
}

// MARK: - Window Overlay View Controller
final class WindowOverlayViewController<Content>: UIViewController where Content: View {
    // MARK: Properties
    private let hostedViewTag: Int = 999_999_999
    private var hostingController: UIHostingController<Content>!

    // MARK: Initializers
    convenience init(
        allowsHitTesting: Bool,
        content: Content
    ) {
        self.init(nibName: nil, bundle: nil)
        
        present(
            allowsHitTesting: allowsHitTesting,
            content: content
        )
    }

    // MARK: Presenting
    private func present(
        allowsHitTesting: Bool,
        content: Content
    ) {
        hostingController = .init(rootView: content)
        
        let hostedView: UIView = hostingController.view
        hostedView.translatesAutoresizingMaskIntoConstraints = false
        hostedView.isUserInteractionEnabled = allowsHitTesting
        hostedView.backgroundColor = .clear
        hostedView.tag = hostedViewTag
        
        guard let appSuperView = UIView.windowView else { fatalError() }
        
        appSuperView.addSubview(hostedView)
        
        NSLayoutConstraint.activate([
            hostedView.leadingAnchor.constraint(equalTo: appSuperView.leadingAnchor),
            hostedView.trailingAnchor.constraint(equalTo: appSuperView.trailingAnchor),
            hostedView.topAnchor.constraint(equalTo: appSuperView.topAnchor),
            hostedView.bottomAnchor.constraint(equalTo: appSuperView.bottomAnchor)
        ])
        
        appSuperView.bringSubviewToFront(hostedView)
    }

    // MARK: Updating
    fileprivate func update(with content: Content) {
        hostingController?.rootView = content
    }

    // MARK: Dismissing
    fileprivate func dismiss() {
        UIView.windowView?.subviews.first(where: { $0.tag == hostedViewTag })?.removeFromSuperview()
    }
}
