//
//  Preview_StretchedButtonFrameModifier.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 21.01.24.
//

#if DEBUG

import SwiftUI

// MARK: - Stretched Button Frame Modifier
struct Preview_StretchedButtonFrameModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
#if os(iOS)
            .padding(.horizontal)
#elseif os(macOS)
            .frame(width: 250)
#elseif os(watchOS)
            .padding(.horizontal)
#elseif os(visionOS)
            .frame(width: 250)
#endif
    }
}

#endif
