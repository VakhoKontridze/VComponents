//
//  _InterfaceOrientation.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 07.08.23.
//

import SwiftUI

// MARK: - _ Interface Orientation
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
enum _InterfaceOrientation {
    // MARK: Cases
    case portrait
    case landscape

    // MARK: Initializers
#if canImport(UIKit) && !(os(tvOS) || os(watchOS) || os(visionOS))
    init(uiIInterfaceOrientation: UIInterfaceOrientation) {
        if uiIInterfaceOrientation.isLandscape {
            self = .landscape
        } else {
            self = .portrait
        }
    }
#endif

    static func initFromSystemInfo() -> Self {
#if canImport(UIKit) && !(os(tvOS) || os(watchOS) || os(visionOS))
        if UIDevice.current.orientation.isLandscape {
            .landscape
        } else {
            .portrait
        }
#else
        fatalError() // Not supported
#endif
    }
}
