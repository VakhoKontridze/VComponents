//
//  UIApplication.AppKeyWindow.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 4/14/22.
//

import UIKit

// MARK: - Root
extension UIApplication {
    /// Root `UIWindow` in application.
    public static var rootWindow: UIWindow? {
        UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .compactMap { $0.keyWindow }
            .first
    }
}

// MARK: - Active
extension UIApplication {
    /// Active `UIWindow` in application.
    public static var activeWindow: UIWindow? {
        UIApplication.shared
            .connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first { $0 is UIWindowScene }
            .flatMap { $0 as? UIWindowScene }?
            .windows
            .first(where: \.isKeyWindow)
    }
    
    /// Active `UIViewController` in application.
    public static var activeViewController: UIViewController? {
        activeWindow?.rootViewController
    }
    
    /// Active `UIView` in application.
    public static var activeView: UIView? {
        activeViewController?.view
    }
}

// MARK: - Top-Most
extension UIApplication {
    /// Top-most `UIViewController` in application.
    public static var topMostViewController: UIViewController? {
        guard
            let activeWindow = activeWindow,
            var topMostViewController: UIViewController = activeWindow.rootViewController
        else {
            return nil
        }

        while let presentedViewController = topMostViewController.presentedViewController {
            topMostViewController = presentedViewController
        }

        return topMostViewController
    }
    
    /// Top-most `UIView` in application.
    public static var topMostView: UIView? {
        topMostViewController?.view
    }
}
