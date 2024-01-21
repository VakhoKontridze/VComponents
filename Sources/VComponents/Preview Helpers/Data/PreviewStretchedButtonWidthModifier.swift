//
//  PreviewStretchedButtonWidthModifier.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 21.01.24.
//

#if DEBUG

import SwiftUI

// MARK: - Preview Stretched Button Width Modifier
struct PreviewStretchedButtonWidthModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .applyModifier({
#if os(iOS)
                $0.padding(.horizontal)
#elseif os(macOS)
                $0.frame(width: 250)
#elseif os(watchOS)
                $0.padding(.horizontal)
#else
                fatalError() // Not supported
#endif
            })
    }
}

#endif
