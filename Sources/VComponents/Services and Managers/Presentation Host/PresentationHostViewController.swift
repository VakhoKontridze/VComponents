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
    
    private static var storage: [String: PresentationHostViewController] = [:]
    
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
        
        Self.storage[id] = self
    }
    
    func updateHostedView(with content: some View) {
        hostingController?.rootView = .init(content)
    }
    
    func dismissHostedView() {
        dismissHostedView(force: false)
    }
    
    static func forceDismiss(id: String) {
        Self.storage[id]?.dismissHostedView(force: true)
    }
    
    private func dismissHostedView(force: Bool) {
        if force {
            if
                let activeViewController: UIViewController = UIApplication.shared.activeViewController,
                activeViewController.presentedViewController == hostingController
            {
                activeViewController.dismiss(animated: false, completion: nil)
            }
        } else {
            dismiss(animated: true, completion: nil)
        }
        hostingController = nil
        _ = Self.storage.removeValue(forKey: id)
        
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
