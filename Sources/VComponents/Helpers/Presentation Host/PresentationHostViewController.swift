//
//  PresentationHostViewController.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 4/14/22.
//

import SwiftUI
import VCore

// MARK: - Presentation Host View Controller
/// Presentation Host ViewController that's wrapped to `SwiftUI` `View` by `PresentationHost`.
///
/// Hosts an `UIHostingController` with content from modal.
///
/// `UIHostingController` is configured with:
///  - `overFullScreen` `modalPresentationStyle`
///  - `crossDissolve` `modalTransitionStyle`
///  - `clear` `backgroundColor`
///
///  Clicks behind the modal do not go through.
///
/// For additional documetation, refer to `PresentationHost`.
public final class PresentationHostViewController: UIViewController {
    // MARK: Properties
    private var hostingController: HostingViewControllerType?
    typealias HostingViewControllerType = UIHostingController<AnyView>
    
    private let allowsHitTests: Bool
    
    private var windowView: UIView? { UIApplication.shared.activeView }
    
    private static let idGenerator: AtomicInteger = .init(initialValue: 1_000_000)
    private var id: Int?
    
    // MARK: Initializers
    /// Initializes `PresentationHostViewController`.
    public init(
        allowsHitTests: Bool
    ) {
        self.allowsHitTests = allowsHitTests
        super.init(nibName: nil, bundle: nil)
    }
    
    /// Initializes `PresentationHostViewController`.
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Presentation
    func presentHostedView<Content>(_ content: Content) where Content: View {
        guard
            id == nil,
            let windowView = windowView
        else {
            return
        }
        
        hostingController = .init(rootView: .init(
            content.frame(maxWidth: .infinity, maxHeight: .infinity)
        ))
        guard let hostingController = hostingController else { return }
        
        let id: Int = Self.idGenerator.value
        self.id = id
        hostingController.view.tag = id
        
        hostingController.modalPresentationStyle = .overFullScreen
        hostingController.modalTransitionStyle = .crossDissolve
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.isUserInteractionEnabled = allowsHitTests
        hostingController.view.backgroundColor = .clear
        
        windowView.addSubview(hostingController.view)
        windowView.bringSubviewToFront(hostingController.view)
        
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: windowView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: windowView.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: windowView.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: windowView.bottomAnchor)
        ])
    }
    
    func updateHostedView<Content>(with content: Content) where Content: View {
        hostingController?.rootView = .init(
            content.frame(maxWidth: .infinity, maxHeight: .infinity)
        )
    }
    
    func dismissHostedView() {
        guard let windowView = windowView else { return }
        
        windowView.subviews.first(where: { $0.tag == id })?.removeFromSuperview()
        id = nil
    }
}
