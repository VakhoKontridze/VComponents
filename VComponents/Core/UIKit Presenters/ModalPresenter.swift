//
//  ModalPresenter.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI

// MARK:- V Modal VC Representable
struct VModalVCRepresentable<ModalContent, BlindingContent>
    where
        ModalContent: View,
        BlindingContent: View
{
    // MARK: Properties
    @Binding private var isPresented: Bool
    
    private let content: ModalContent
    private let blinding: BlindingContent
    
    private let backTapAction: (() -> Void)?

    // MARK: Initializers
    init(
        isPresented: Binding<Bool>,
        content: ModalContent,
        blinding: BlindingContent,
        onBackTap backTapAction: (() -> Void)? = nil
    ) {
        self._isPresented = isPresented
        self.content = content
        self.blinding = blinding
        self.backTapAction = backTapAction
    }
}

// MARK:- Representable
extension VModalVCRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(
        context: UIViewControllerRepresentableContext<Self>
    ) -> VModalVC<ModalContent, BlindingContent> {
        .init(content: content, blinding: blinding, onBackTap: backTapAction)
    }

    func updateUIViewController(
        _ uiViewController: VModalVC<ModalContent, BlindingContent>,
        context: UIViewControllerRepresentableContext<Self>
    ) {
        switch isPresented {
        case false:
            uiViewController.dismiss()
        
        case true:
            uiViewController.modalHC?.rootView = content
            uiViewController.blindingHC?.rootView = blinding
        }
    }
}

// MARK:- V Modal VC
final class VModalVC<ModalContent, BlindingContent>: UIViewController
    where
        ModalContent: View,
        BlindingContent: View
{
    // MARK: Properties
    private let modalID: Int = 999_999_999
    private let blindingID: Int = 999_999_998
    
    fileprivate var modalHC: UIHostingController<ModalContent>!
    fileprivate var blindingHC: UIHostingController<BlindingContent>!
    
    private var initialTransform: CGAffineTransform { .init(scaleX: 1.01, y: 1.01) }
    private var presentedTransform: CGAffineTransform { .init(scaleX: 1, y: 1) }
    private var dismissedTransform: CGAffineTransform { presentedTransform }
    private let animationCurve: UIView.AnimationOptions = UIView.AnimationCurve.linear.animationOption
    private let animationDuration: TimeInterval = 0.1
    
    private let backTapAction: (() -> Void)?

    // MARK: Initializers
    init(
        content: ModalContent,
        blinding: BlindingContent,
        onBackTap backTapAction: (() -> Void)?
    ) {
        self.backTapAction = backTapAction
        super.init(nibName: nil, bundle: nil)
        present(content, blinding: blinding)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Misc
    // Extensions of generic classes cannot contain '@objc' members
    @objc func didTapBlindingView(_ sender: UITapGestureRecognizer) { backTapAction?() }
}

// MARK:- Presenting
private extension VModalVC {
    func present(_ content: ModalContent, blinding: BlindingContent) {
        presentBlinding(blinding)
        presentModal(content)
    }
    
    func presentBlinding(_ blinding: BlindingContent) {
        blindingHC = UIKitPresenterCommon.presentBlinding(blinding, id: blindingID)
        
        let tapGesture: UITapGestureRecognizer = .init(target: self, action: #selector(didTapBlindingView))
        blindingHC?.view.addGestureRecognizer(tapGesture)
    }
    
    func presentModal(_ content: ModalContent) {
        guard let appSuperView = UIKitPresenterCommon.appSuperView else { return }
        
        modalHC = UIKitPresenterCommon.createHostingController(content: content, id: modalID)
        let modalView: UIView = modalHC.view
        
        appSuperView.addSubview(modalView)
        NSLayoutConstraint.activate([
            modalView.centerXAnchor.constraint(equalTo: appSuperView.centerXAnchor),
            modalView.centerYAnchor.constraint(equalTo: appSuperView.centerYAnchor)
        ])
        appSuperView.bringSubviewToFront(modalView)
        
        modalView.transform = initialTransform
        UIView.animate(
            withDuration: animationDuration,
            delay: 0,
            options: animationCurve,
            animations: { [weak self] in
                guard let self = self else { return }
                modalView.transform = self.presentedTransform
            },
            completion: nil
        )
    }
}

// MARK:- Dismissing
private extension VModalVC {
    func dismiss() {
        dismissBlinding()
        dismissModal()
    }
    
    func dismissBlinding() {
        UIKitPresenterCommon.dismissView(id: blindingID)
    }
    
    func dismissModal() {
        guard let modalView = UIKitPresenterCommon.view(id: modalID) else { return }
        
        modalView.transform = presentedTransform
        UIView.animate(
            withDuration: animationDuration,
            delay: 0,
            options: [animationCurve, .transitionCrossDissolve],
            animations: { [weak self] in
                guard let self = self else { return }
                modalView.transform = self.dismissedTransform
            },
            completion: { _ in
                modalView.removeFromSuperview()
            }
        )
    }
}
