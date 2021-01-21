//
//  UIVIewExtensions.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/21/21.
//

import UIKit

// MARK:- Safe Area
extension UIView {
    static var bottomSafeAreaHeight: CGFloat {
        appSuperView?.safeAreaInsets.bottom ?? 0
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
