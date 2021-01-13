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

    // MARK: Initializers
    init(isPresented: Binding<Bool>, content: ModalContent, blinding: BlindingContent) {
        self._isPresented = isPresented
        self.content = content
        self.blinding = blinding
    }
}

// MARK:- Representable
extension VModalVCRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(
        context: UIViewControllerRepresentableContext<VModalVCRepresentable>
    ) -> VModalVC<ModalContent, BlindingContent> {
        VModalVC(content: content, blinding: blinding)
    }

    func updateUIViewController(
        _ uiViewController: VModalVC<ModalContent, BlindingContent>,
        context: UIViewControllerRepresentableContext<VModalVCRepresentable>
    ) {
        switch isPresented {
        case false:
            uiViewController.dismiss()
        
        case true:
            uiViewController.modalHC?.rootView = content
            uiViewController.blindingHC?.rootView = blinding
        }
    }
    
//    func makeUIViewController(context: Context) -> UIHostingController<Content> {
//        .init(rootView: content)
//    }
//
//    func updateUIViewController(_ host: UIHostingController<Content>, context: Context) {
//        host.rootView = content
//    }
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
    
    var modalHC: UIHostingController<ModalContent>?
    var blindingHC: UIHostingController<BlindingContent>?

    // MARK: Initializers
    init(content: ModalContent, blinding: BlindingContent) {
        super.init(nibName: nil, bundle: nil)
        present(content, blinding: blinding)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- Presenting
private extension VModalVC {
    func present(_ content: ModalContent, blinding: BlindingContent) {
        guard let appSuperView = appSuperView else { return }
        
        addBlinding(blinding, in: appSuperView)
        addModal(content, in: appSuperView)
    }
    
    func addBlinding(_ blinding: BlindingContent, in appSuperView: UIView) {
        let blindingHC: UIHostingController = createHostingController(with: blinding, id: blindingID)
        self.blindingHC = blindingHC
        
        let blindingView: UIView = blindingHC.view

        appSuperView.addSubview(blindingView)
        
        NSLayoutConstraint.activate([
            blindingView.widthAnchor.constraint(equalToConstant: appSuperView.frame.width),
            blindingView.heightAnchor.constraint(equalToConstant: appSuperView.frame.height),
            blindingView.centerXAnchor.constraint(equalTo: appSuperView.centerXAnchor),
            blindingView.centerYAnchor.constraint(equalTo: appSuperView.centerYAnchor)
        ])
        
        blindingView.bringSubviewToFront(blindingView)
    }
    
    func addModal(_ content: ModalContent, in appSuperView: UIView) {
        let modalHC: UIHostingController = createHostingController(with: content, id: modalID)
        self.modalHC = modalHC
        
        let modalView: UIView = modalHC.view
        
        appSuperView.addSubview(modalView)
        
        NSLayoutConstraint.activate([
            modalView.centerXAnchor.constraint(equalTo: appSuperView.centerXAnchor),
            modalView.centerYAnchor.constraint(equalTo: appSuperView.centerYAnchor)
        ])
        
        appSuperView.bringSubviewToFront(modalView)
        
        modalView.transform = .init(scaleX: 1.01, y: 1.01)
        UIView.animate(
            withDuration: 0.1,
            delay: 0,
            options: .curveEaseOut,
            animations: { modalView.transform = .identity },
            completion: nil
        )
    }
}

// MARK:- Dismissing
extension VModalVC {
    func dismiss() {
        guard let appSuperView = appSuperView else { return }
        
        dismissBlinding(from: appSuperView)
        dismissModal(from: appSuperView)
    }
    
    private func dismissBlinding(from appSuperView: UIView) {
        guard let blinding = blindingView(in: appSuperView) else { return }
        blinding.removeFromSuperview()
    }
    
    private func dismissModal(from appSuperView: UIView) {
        guard let modalView = modalView(in: appSuperView) else { return }
        
        UIView.transition(
            with: appSuperView,
            duration: 0.1,
            options: .transitionCrossDissolve,
            animations: { modalView.removeFromSuperview() },
            completion: nil
        )
    }
}

// MARK:- Subviews
private extension VModalVC {
    func modalView(in appSuperView: UIView) -> UIView? {
        appSuperView.subviews.first(where: { $0.tag == modalID })
    }
    
    func blindingView(in appSuperView: UIView) -> UIView? {
        appSuperView.subviews.first(where: { $0.tag == blindingID })
    }
    
    var appSuperView: UIView? {
        guard
            let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
            let rootVC = keyWindow.rootViewController,
            let appSuperView = rootVC.navigationController?.view ?? rootVC.view
        else {
            return nil
        }
        
        return appSuperView
    }
}
    
// MARK:- Helpers
private extension VModalVC {
    func createHostingController<Content>(
        with content: Content,
        id: Int
    ) -> UIHostingController<Content>
        where Content: View
    {
        let hostingController: UIHostingController = .init(rootView: content)
        let modalView: UIView = hostingController.view
        modalView.translatesAutoresizingMaskIntoConstraints = false
        modalView.backgroundColor = .clear
        modalView.tag = id
        return hostingController
    }
}
