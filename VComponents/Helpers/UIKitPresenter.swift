//
//  UIKitPresenter.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/21/21.
//

import SwiftUI

// MARK:- UI Kit Representable
struct UIKitRepresentable<Content> where Content: View {
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
}

// MARK:- Representabe
extension UIKitRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIKitPresenterVC<Content> {
        .init(allowsHitTesting: allowsHitTesting, content: content)
    }

    func updateUIViewController(_ uiViewController: UIKitPresenterVC<Content>, context: Context) {
        switch isPresented {
        case false: uiViewController.dismiss()
        case true: uiViewController.update(with: content)
        }
    }
}

// MARK:- UI Kit Presenter VC
final class UIKitPresenterVC<Content>: UIViewController where Content: View {
    // MARK: Properties
    private let hostedViewTag: Int = 999_999_999
    private var hostingController: UIHostingController<Content>!

    // MARK: Initializers
    init(
        allowsHitTesting: Bool,
        content: Content
    ) {
        super.init(nibName: nil, bundle: nil)
        present(
            allowsHitTesting: allowsHitTesting,
            content: content
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- Presenting
extension UIKitPresenterVC {
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
        
        guard let appSuperView = UIView.appSuperView else { preconditionFailure() }
        
        appSuperView.addSubview(hostedView)
        
        NSLayoutConstraint.activate([
            hostedView.leadingAnchor.constraint(equalTo: appSuperView.leadingAnchor),
            hostedView.trailingAnchor.constraint(equalTo: appSuperView.trailingAnchor),
            hostedView.topAnchor.constraint(equalTo: appSuperView.topAnchor),
            hostedView.bottomAnchor.constraint(equalTo: appSuperView.bottomAnchor)
        ])
        
        appSuperView.bringSubviewToFront(hostedView)
    }
}

// MARK:- Updating
extension UIKitPresenterVC {
    fileprivate func update(with content: Content) {
        hostingController?.rootView = content
    }
}

// MARK:- Dismissing
extension UIKitPresenterVC {
    fileprivate func dismiss() {
        UIView.appSuperView?.subviews.first(where: { $0.tag == hostedViewTag })?.removeFromSuperview()
    }
}
