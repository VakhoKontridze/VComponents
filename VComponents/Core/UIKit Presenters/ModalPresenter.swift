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
    
    private let animationDuration: TimeInterval = 0.1
    
    fileprivate var modalHC: UIHostingController<ModalContent>!
    fileprivate var blindingHC: UIHostingController<BlindingContent>!
    
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
        addBlinding(blinding)
        addModal(content)
    }
    
    func addBlinding(_ blinding: BlindingContent) {
        blindingHC = UIKitPresenterCommon.addBlinding(blinding, id: blindingID)
        
        let tapGesture: UITapGestureRecognizer = .init(target: self, action: #selector(didTapBlindingView))
        blindingHC?.view.addGestureRecognizer(tapGesture)
    }
    
    func addModal(_ content: ModalContent) {
        guard let appSuperView = UIKitPresenterCommon.appSuperView else { return }
        
        modalHC = UIKitPresenterCommon.createHostingController(content: content, id: modalID)
        let modalView: UIView = modalHC.view
        
        appSuperView.addSubview(modalView)
        NSLayoutConstraint.activate([
            modalView.centerXAnchor.constraint(equalTo: appSuperView.centerXAnchor),
            modalView.centerYAnchor.constraint(equalTo: appSuperView.centerYAnchor)
        ])
        appSuperView.bringSubviewToFront(modalView)
        
        modalView.transform = beginTransform
        UIView.animate(
            withDuration: animationDuration,
            delay: 0,
            options: .curveEaseInOut,
            animations: { [weak self] in
                guard let self = self else { return }
                modalView.transform = self.presentTransform
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
        
        modalView.transform = presentTransform
        UIView.animate(
            withDuration: animationDuration,
            delay: 0,
            options: [.curveEaseInOut, .transitionCrossDissolve],
            animations: { [weak self] in
                guard let self = self else { return }
                modalView.transform = self.endTransform
            },
            completion: { _ in
                modalView.removeFromSuperview()
            }
        )
    }
}

// MARK:- Transforms
private extension VModalVC {
    var beginTransform: CGAffineTransform { .init(scaleX: 1.01, y: 1.01) }
    var presentTransform: CGAffineTransform { .init(scaleX: 1, y: 1) }
    var endTransform: CGAffineTransform { presentTransform }
}
