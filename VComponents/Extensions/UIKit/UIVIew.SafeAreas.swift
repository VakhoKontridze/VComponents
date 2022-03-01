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
        UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.safeAreaInsets.top ?? 0
    }

    static var bottomSafeAreaHeight: CGFloat {
        UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.safeAreaInsets.bottom ?? 0
    }
}
