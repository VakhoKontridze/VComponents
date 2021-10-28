//
//  UINavigationBar.NavigationBarHeight.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 10/28/21.
//

import UIKit

// MARK: - Navigation Bar Height
extension UINavigationBar {
    static let height: CGFloat =
        UINavigationController(rootViewController: .init(nibName: nil, bundle: nil))
            .navigationBar
            .frame
            .size
            .height
}
