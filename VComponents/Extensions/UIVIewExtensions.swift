//
//  UIVIewExtensions.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/21/21.
//

import UIKit

// MARK: - Constants
extension UIView {
    static var topSafeAreaHeight: CGFloat {
        windowView?.safeAreaInsets.top ?? 0
    }

    static var bottomSafeAreaHeight: CGFloat {
        windowView?.safeAreaInsets.bottom ?? 0
    }
    
    static var navigationBarHeight: CGFloat {
        let navigationController: UINavigationController = .init(rootViewController: .init(nibName: nil, bundle: nil))
        return navigationController.navigationBar.frame.size.height
    }
}

// MARK: - Window View
extension UIView {
    static var windowView: UIView? {
        guard
            let keyWindow: UIWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
            let rootVC: UIViewController = keyWindow.rootViewController,
            let windowView: UIView = rootVC.navigationController?.view ?? rootVC.view
        else {
            return nil
        }
        
        return windowView
    }
}
