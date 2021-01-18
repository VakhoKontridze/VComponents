//
//  UIKitPresenterCommon.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/15/21.
//

import SwiftUI
    
// MARK:- UIKit Presenter Common
final class UIKitPresenterCommon {
    private init() {}
}

// MARK:- Presenting
extension UIKitPresenterCommon {
    static func presentBlinding<Content>(
        _ blinding: Content,
        id: Int
    ) -> UIHostingController<Content>?
        where Content: View
    {
        guard let appSuperView = appSuperView else { return nil }
        
        let blindingHC: UIHostingController = createHostingController(content: blinding, id: id)
        let blindingView: UIView = blindingHC.view
        
        appSuperView.addSubview(blindingView)
        NSLayoutConstraint.activate([
            blindingView.widthAnchor.constraint(equalToConstant: appSuperView.frame.width),
            blindingView.heightAnchor.constraint(equalToConstant: appSuperView.frame.height),
            blindingView.centerXAnchor.constraint(equalTo: appSuperView.centerXAnchor),
            blindingView.centerYAnchor.constraint(equalTo: appSuperView.centerYAnchor)
        ])
        blindingView.bringSubviewToFront(blindingView)
        
        return blindingHC
    }
}

// MARK:- Dismissing
extension UIKitPresenterCommon {
    static func dismissView(id: Int) {
        view(id: id)?.removeFromSuperview()
    }
}

// MARK:- Views
extension UIKitPresenterCommon {
    static var appSuperView: UIView? {
        guard
            let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
            let rootVC = keyWindow.rootViewController,
            let appSuperView = rootVC.navigationController?.view ?? rootVC.view
        else {
            return nil
        }
        
        return appSuperView
    }
    
    static func view(id: Int) -> UIView? {
        appSuperView?.subviews.first(where: { $0.tag == id })
    }
}

// MARK:- Creating Hosting Controller
extension UIKitPresenterCommon {
    static func createHostingController<Content>(
        content: Content,
        id: Int?
    ) -> UIHostingController<Content>
        where Content: View
    {
        let hostingController: UIHostingController = .init(rootView: content)
        
        let modalView: UIView = hostingController.view
        modalView.translatesAutoresizingMaskIntoConstraints = false
        modalView.backgroundColor = .clear
        if let id = id { modalView.tag = id }
        
        return hostingController
    }
}

//    func makeUIViewController(context: Context) -> UIHostingController<Content> {
//        .init(rootView: content)
//    }
//
//    func updateUIViewController(_ host: UIHostingController<Content>, context: Context) {
//        host.rootView = content
//    }

// MARK:- Animation Curve Mappng
extension UIView.AnimationCurve {
    var animationOption: UIView.AnimationOptions {
        switch self {
        case .linear: return .curveLinear
        case .easeIn: return .curveEaseIn
        case .easeOut: return .curveEaseOut
        case .easeInOut: return .curveEaseOut
        @unknown default: return .curveLinear
        }
    }
}
