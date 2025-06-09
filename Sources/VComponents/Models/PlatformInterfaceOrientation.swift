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
    @MainActor
    static func initFromDeviceOrientation() -> Self {
#if os(macOS) || os(tvOS) || os(watchOS) || os(visionOS)
        .portrait
#else
        if UIDevice.current.orientation.isLandscape {
            .landscape
        } else {
            .portrait
        }
#endif
    }

#if !(os(macOS) || os(tvOS) || os(watchOS) || os(visionOS))
    init(uiIInterfaceOrientation: UIInterfaceOrientation) {
        self = {
            if uiIInterfaceOrientation.isLandscape {
                .landscape
            } else {
                .portrait
            }
        }()
    }
#endif
}
