//
//  UIWindow.SafeAreas.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/21/21.
//

import UIKit

// MARK: - Window Safe Areas
extension UIWindow {
    /// Safe area insets in window.
    public static var safeAreaInsets: UIEdgeInsets? {
        UIApplication.rootWindow?.safeAreaInsets
    }
    
    /// Left safe area inset in window.
    public static var safeAreaInsetLeft: CGFloat {
        safeAreaInsets?.left ?? 0
    }

    /// Right safe area inset in window.
    public static var safeAreaInsetRight: CGFloat {
        safeAreaInsets?.right ?? 0
    }

    /// Top safe area inset in window.
    public static var safeAreaInsetTop: CGFloat {
        safeAreaInsets?.top ?? 0
    }

    /// Bottom safe area inset in window.
    public static var safeAreaInsetBottom: CGFloat {
        safeAreaInsets?.bottom ?? 0
    }
}
