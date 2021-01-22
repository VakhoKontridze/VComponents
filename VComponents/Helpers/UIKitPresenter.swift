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
    @Binding private var isPresented: Bool
    private let content: Content

    // MARK: Initializers
    init(isPresented: Binding<Bool>, content: Content) {
        self._isPresented = isPresented
        self.content = content
    }
}

// MARK:- Representabe
extension UIKitRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIKitPresenterVC<Content> {
        .init(content: content)
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
    init(content: Content) {
        super.init(nibName: nil, bundle: nil)
        present(content)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- Presenting
private extension UIKitPresenterVC {
    func present(_ content: Content) {
        let hostingController: UIHostingController = .init(rootView: content)
        
        let hostedView: UIView = hostingController.view
        hostedView.translatesAutoresizingMaskIntoConstraints = false
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
fileprivate extension UIKitPresenterVC {
    func update(with content: Content) {
        hostingController?.rootView = content
    }
}

// MARK:- Dismissing
private extension UIKitPresenterVC {
    func dismiss() {
        UIView.appSuperView?.subviews.first(where: { $0.tag == hostedViewTag })?.removeFromSuperview()
    }
}
