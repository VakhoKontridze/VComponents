//
//  VAlertPresenter.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI

// MARK:- V Alert Presenter
struct VAlertPresenter {
    private static let alertID: Int = 999_999_999
    private static let blindingID: Int = 999_999_998
}

// MARK:- API
extension VAlertPresenter {
    static func present<AlertContent>(
        _ alert: AlertContent,
        if isPresented: Binding<Bool>
    )
        where AlertContent: View
    {
        if isPresented.wrappedValue {
            VAlertPresenter.present(alert)
        } else {
            VAlertPresenter.dismiss()
        }
    }
}

// MARK:- Presenting
private extension VAlertPresenter {
    static func present<AlertContent>(_ alert: AlertContent) where AlertContent: View {
        guard let superView = superView else { return }
        
        addBlinding(in: superView)
        let alertUIView: UIView = addAlert(in: superView, with: alert)
        animateIn(alertUIView)
    }
    
    static func addBlinding(in superView: UIView) {
        let blinding: UIView = {
            let blinding: UIView = .init()
            blinding.translatesAutoresizingMaskIntoConstraints = false
            blinding.isUserInteractionEnabled = false
            blinding.backgroundColor = .init(ColorBook.SideBarStandard.blinding)
            blinding.tag = blindingID
            return blinding
        }()
        
        superView.addSubview(blinding)
        
        NSLayoutConstraint.activate([
            blinding.widthAnchor.constraint(equalToConstant: superView.frame.width),
            blinding.heightAnchor.constraint(equalToConstant: superView.frame.height),
            blinding.centerXAnchor.constraint(equalTo: superView.centerXAnchor),
            blinding.centerYAnchor.constraint(equalTo: superView.centerYAnchor)
        ])
        
        superView.bringSubviewToFront(blinding)
    }
    
    static func addAlert<AlertContent>(
        in superView: UIView,
        with content: AlertContent
    ) -> UIView
        where AlertContent: View
    {
        let alertUIView: UIView = {
            let hostingController: UIHostingController = .init(rootView: content)
            let alertUIView: UIView = hostingController.view
            alertUIView.translatesAutoresizingMaskIntoConstraints = false
            alertUIView.tag = alertID
            return alertUIView
        }()
        
        superView.addSubview(alertUIView)
        
        NSLayoutConstraint.activate([
            alertUIView.centerXAnchor.constraint(equalTo: superView.centerXAnchor),
            alertUIView.centerYAnchor.constraint(equalTo: superView.centerYAnchor)
        ])
        
        superView.bringSubviewToFront(alertUIView)
        
        return alertUIView
    }
    
    static func animateIn(_ alertUIView: UIView) {
        alertUIView.transform = .init(scaleX: 1.01, y: 1.01)
        UIView.animate(
            withDuration: 0.1,
            delay: 0,
            options: .curveEaseOut,
            animations: { alertUIView.transform = .identity },
            completion: nil
        )
    }
}

// MARK:- Dismissing
private extension VAlertPresenter {
    static func dismiss() {
        guard let superView = superView else { return }
        
        dismissBlinding(from: superView)
        dismissAlertAnfAniamteOut(from: superView)
    }
    
    static func dismissBlinding(from superView: UIView) {
        guard let blinding = superView.subviews.first(where: { $0.tag == blindingID }) else { return }
        blinding.removeFromSuperview()
    }
    
    static func dismissAlertAnfAniamteOut(from superView: UIView) {
        guard let alertUIView = superView.subviews.first(where: { $0.tag == alertID }) else { return }
        
        UIView.transition(
            with: superView,
            duration: 0.1,
            options: .transitionCrossDissolve,
            animations: { alertUIView.removeFromSuperview() },
            completion: nil
        )
    }
}
    
// MARK:- Helpers
private extension VAlertPresenter {
    static private var superView: UIView? {
        guard
            let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
            let rootVC = keyWindow.rootViewController,
            let superView = rootVC.navigationController?.view ?? rootVC.view
        else {
            return nil
        }
        
        return superView
    }
}
