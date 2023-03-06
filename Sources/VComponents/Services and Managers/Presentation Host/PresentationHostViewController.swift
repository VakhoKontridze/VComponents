//
//  PresentationHostViewController.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 4/14/22.
//

import SwiftUI
import VCore

// MARK: - Presentation Host View Controller
final class PresentationHostViewController: UIViewController {
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
        guard let windowView: UIView = UIApplication.shared.activeView else { return }
        
        hostingController = .init(rootView: .init(content))
        guard let hostingController = hostingController else { fatalError() }
        
        hostingController.view.tag = id.asViewTag
        
        hostingController.modalPresentationStyle = .overFullScreen
        hostingController.modalTransitionStyle = .crossDissolve
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.isUserInteractionEnabled = allowsHitTests
        hostingController.view.backgroundColor = .clear
        
        windowView.addSubview(hostingController.view)
        windowView.bringSubviewToFront(hostingController.view)
        
        NSLayoutConstraint.activate([
            hostingController.view.constraintLeading(to: windowView),
            hostingController.view.constraintTrailing(to: windowView),
            hostingController.view.constraintTop(to: windowView),
            hostingController.view.constraintBottom(to: windowView)
        ])
        
        Self.storage[id] = self
    }
    
    func updateHostedView(with content: some View) {
        hostingController?.rootView = .init(content)
    }
    
    func dismissHostedView() {
        UIApplication.shared.activeView?.subviews.first(where: { $0.tag == id.asViewTag })?.removeFromSuperview()
        hostingController = nil
        
        PresentationHostDataSourceCache.shared.remove(key: id)
        
        _ = Self.storage.removeValue(forKey: id)
    }
    
    // MARK: Force Dismiss
    static func forceDismiss(id: String) {
        Self.storage[id]?.dismissHostedView()
    }
}

// MARK: - Helpers
extension String {
    fileprivate var asViewTag: Int {
        hashValue
    }
}
