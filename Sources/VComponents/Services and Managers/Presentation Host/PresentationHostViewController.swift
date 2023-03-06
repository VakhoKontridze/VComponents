//
//  PresentationHostViewController.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 4/14/22.
//

import SwiftUI
import VCore

// MARK: - Presentation Host View Controller
final class PresentationHostViewController: UIViewController, UIViewControllerTransitioningDelegate {
    // MARK: Properties
    private let id: String
    private let allowsHitTests: Bool
    
    typealias HostingViewControllerType = UIHostingController<AnyView>
    private var hostingController: HostingViewControllerType?
    
    var isPresentingView: Bool { hostingController != nil }
    
    // MARK: Initializers
    init(
        id: String,
        allowsHitTests: Bool
    ) {
        self.id = id
        self.allowsHitTests = allowsHitTests
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Presentation
    func presentHostedView(_ content: some View) {
        hostingController = .init(rootView: .init(content))
        guard let hostingController = hostingController else { fatalError() }
        
        hostingController.modalPresentationStyle = .overFullScreen
        hostingController.modalTransitionStyle = .crossDissolve
        hostingController.transitioningDelegate = self
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.backgroundColor = .clear
        
        present(hostingController, animated: true, completion: nil)
        
        PresentationHostViewControllerStorage.shared.storage[id] = self
    }
    
    func updateHostedView(with content: some View) {
        hostingController?.rootView = .init(content)
    }
    
    func dismissHostedView() {
        dismissHostedView(force: false)
    }
    
    static func forceDismiss(id: String) {
        PresentationHostViewControllerStorage.shared.storage[id]?.dismissHostedView(force: true)
    }
    
    private func dismissHostedView(force: Bool) {
        if force {
            if
                let rootViewController: UIViewController = UIApplication.shared.firstWindow(where: { window in
                    window.rootViewController?.presentedViewController == hostingController
                })?.rootViewController
            {
                rootViewController.dismiss(animated: false, completion: nil)
            }
        } else {
            dismiss(animated: true, completion: nil)
        }
        hostingController = nil
        _ = PresentationHostViewControllerStorage.shared.storage.removeValue(forKey: id)
        
        PresentationHostDataSourceCache.shared.remove(key: id)
    }
    
    // MARK: View Controller Transitioning Delegate
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        PresentationHostAnimatedTransitioner(allowsHitTests: allowsHitTests)
    }
}
