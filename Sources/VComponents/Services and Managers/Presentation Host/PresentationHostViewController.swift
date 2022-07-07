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
/// For additional documentation, refer to `PresentationHost`.
public final class PresentationHostViewController: UIViewController {
    // MARK: Properties
    private let presentingViewType: String
    private let allowsHitTests: Bool
    
    private var hostingController: HostingViewControllerType?
    typealias HostingViewControllerType = UIHostingController<AnyView>
    var isPresentingView: Bool { hostingController != nil }
    
    private static var activePresentingViews: Set<String> = []
    
    private static let instanceIDGenerator: AtomicInteger = .init()
    let instanceID: Int
    
    // MARK: Initializers
    /// Initializes `PresentationHostViewController`.
    public init(
        presentingViewType: String,
        allowsHitTests: Bool
    ) {
        self.presentingViewType = presentingViewType
        self.allowsHitTests = allowsHitTests
        self.instanceID = Self.instanceIDGenerator.value
        
        super.init(nibName: nil, bundle: nil)
    }
    
    /// Initializes `PresentationHostViewController`.
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Presentation
    func presentHostedView(_ content: some View) {
        guard let windowView: UIView = UIApplication.shared.activeView else { return }
        
        hostingController = .init(rootView: .init(content))
        guard let hostingController = hostingController else { fatalError() }
        
        Self.activePresentingViews.insert(presentingViewType)
        hostingController.view.tag = presentingViewType.hashValue
        
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
    }
    
    func updateHostedView(with content: some View) {
        hostingController?.rootView = .init(content)
    }
    
    func dismissHostedView() {
        UIApplication.shared.activeView?.subviews.first(where: { $0.tag == presentingViewType.hashValue })?.removeFromSuperview()
        hostingController = nil
        
        Self.activePresentingViews.remove(presentingViewType)
        
        PresentationHostDataSourceCache.shared.remove(key: presentingViewType)
    }
    
    // MARK: Force Dismiss
    static func forceDismiss(in presentingView: some View) {
        let presentingViewType: String = SwiftUIViewTypeDescriber.describe(presentingView)
        
        UIApplication.shared.activeView?.subviews.first(where: { $0.tag == presentingViewType.hashValue })?.removeFromSuperview()
        
        Self.activePresentingViews.remove(presentingViewType)
        
        PresentationHostDataSourceCache.shared.remove(key: presentingViewType)
    }
}
