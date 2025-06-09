//
//  View+GetPlatformInterfaceOrientation.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 06.08.23.
//

import SwiftUI
import VCore

// MARK: - View + Get Platform Interface Orientation
extension View {
    func getPlatformInterfaceOrientation(
        _ action: @escaping (PlatformInterfaceOrientation) -> Void
    ) -> some View {
#if os(macOS) || os(tvOS) || os(watchOS) || os(visionOS)
        self
            .onFirstAppear(perform: { action(.portrait) })
#else
        self
            .getInterfaceOrientation({ action(PlatformInterfaceOrientation(uiIInterfaceOrientation: $0)) })
#endif
    }
}
