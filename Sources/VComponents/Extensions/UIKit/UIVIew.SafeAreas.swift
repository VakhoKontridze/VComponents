//
//  UIVIew.SafeAreas.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/21/21.
//

import UIKit

// MARK: - View Safe Areas
extension UIView {
    static var topSafeAreaHeight: CGFloat {
        UIApplication.keyWindow?.safeAreaInsets.top ?? 0
    }

    static var bottomSafeAreaHeight: CGFloat {
        UIApplication.keyWindow?.safeAreaInsets.bottom ?? 0
    }
}

extension UIApplication {
    fileprivate static var keyWindow: UIWindow? {
        UIApplication.shared
            .connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first { $0 is UIWindowScene }
            .flatMap { $0 as? UIWindowScene }?
            .windows
            .first(where: \.isKeyWindow)
    }
}
