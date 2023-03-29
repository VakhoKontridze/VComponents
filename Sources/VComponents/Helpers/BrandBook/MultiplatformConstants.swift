//
//  MultiplatformConstants.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 23.03.23.
//

import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif os(macOS)
import AppKit
#endif

// MARK: - Multiplatform Constants
struct MultiplatformConstants {
    // MARK: Properties
    static var screenSize: CGSize {
#if canImport(UIKit) && !os(watchOS)
        return UIScreen.main.bounds.size
#elseif canImport(UIKit) && os(watchOS)
        fatalError() // Not supported
#elseif os(macOS)
        fatalError() // Not supported
#endif
    }
    
    static var safeAreaInsets: EdgeInsets {
#if canImport(UIKit) && !os(watchOS)
        return EdgeInsets(
            top: UIDevice.safeAreaInsetTop,
            leading: UIDevice.safeAreaInsetLeft,
            bottom: UIDevice.safeAreaInsetBottom,
            trailing: UIDevice.safeAreaInsetRight
        )
#elseif canImport(UIKit) && os(watchOS)
        fatalError() // Not supported
#elseif os(macOS)
        fatalError() // Not supported
#endif
    }
    
    static let screenScale: CGFloat = {
#if canImport(UIKit) && !os(watchOS)
        return UIScreen.main.scale
#elseif canImport(UIKit) && os(watchOS)
        return WKInterfaceDevice.current().screenScale
#elseif os(macOS)
        return (NSScreen.main ?? .init()).backingScaleFactor
#endif
    }()
    
    // MARK: Initializers
    private init() {}
}
