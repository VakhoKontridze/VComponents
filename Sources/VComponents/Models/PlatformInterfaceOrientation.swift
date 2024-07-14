//
//  PlatformInterfaceOrientation.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 07.08.23.
//

import SwiftUI

// MARK: - Platform Interface Orientation
enum PlatformInterfaceOrientation {
    // MARK: Cases
    case portrait
    case landscape

    // MARK: Initializers
    static func initFromDeviceOrientation() -> Self {
#if os(iOS)
        if UIDevice.current.orientation.isLandscape {
            .landscape
        } else {
            .portrait
        }
#else
        .portrait
#endif
    }

#if canImport(UIKit) && !(os(tvOS) || os(watchOS) || os(visionOS))
    init(uiIInterfaceOrientation: UIInterfaceOrientation) {
        if uiIInterfaceOrientation.isLandscape {
            self = .landscape
        } else {
            self = .portrait
        }
    }
#endif
}
