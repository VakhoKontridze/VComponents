//
//  View._GetInterfaceOrientation.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 06.08.23.
//

import SwiftUI
import VCore

// MARK: - View Get Interface Orientation
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension View {
    @ViewBuilder 
    func _getInterfaceOrientation(
        _ action: @escaping (_InterfaceOrientation) -> Void
    ) -> some View {
#if canImport(UIKit) && !(os(tvOS) || os(watchOS) || os(visionOS))
        self
            .getInterfaceOrientation({ action(_InterfaceOrientation(uiIInterfaceOrientation: $0)) })
#else
        fatalError() // Not supported
#endif
    }
}
