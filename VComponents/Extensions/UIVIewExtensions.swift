//
//  UIVIewExtensions.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/21/21.
//

import UIKit

// MARK:- Constants
extension UIView {
    static var navigationBarHeight: CGFloat {
        let navigationController: UINavigationController = .init(rootViewController: .init(nibName: nil, bundle: nil))
        return navigationController.navigationBar.frame.size.height
    }
}

// MARK:- App Super View
extension UIView {
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

}
