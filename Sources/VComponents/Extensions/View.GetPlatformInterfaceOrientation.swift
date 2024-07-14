//
//  View.GetPlatformInterfaceOrientation.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 06.08.23.
//

import SwiftUI
import VCore

// MARK: - View Get Platform Interface Orientation
extension View {
    @ViewBuilder 
    func getPlatformInterfaceOrientation(
        _ action: @escaping (PlatformInterfaceOrientation) -> Void
    ) -> some View {
#if os(iOS)
        self
            .getInterfaceOrientation({ action(PlatformInterfaceOrientation(uiIInterfaceOrientation: $0)) })
#else
        self
            .onFirstAppear(perform: { action(.portrait) })
#endif
    }
}
