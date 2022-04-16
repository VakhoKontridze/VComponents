//
//  PresentationHostViewController.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 4/14/22.
//

import SwiftUI

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
public final class PresentationHostViewController<Content>: UIViewController where Content: View {
    // MARK: Properties
    private var hostingController: HostingViewControllerType?
    typealias HostingViewControllerType = UIHostingController<Content>
    
    // MARK: Initializers
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Presentation
    func presentHostedView(_ content: Content) {
        hostingController = .init(rootView: content)
        guard let hostingController = hostingController else { return }
        
        hostingController.modalPresentationStyle = .overFullScreen
        hostingController.modalTransitionStyle = .crossDissolve
        hostingController.view.backgroundColor = .clear
        
        present(hostingController, animated: false, completion: nil)
    }
    
    func updateHostedView(with content: Content) {
        hostingController?.rootView = content
    }
    
    func dismissHostedView() {
        dismiss(animated: false, completion: nil)
    }
}
