//
//  Color.InitWithRGBA.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VCore

// MARK: - Color Init with RGBA
extension Color {
    @inline(__always)
    init(
        _ red: CGFloat,
        _ green: CGFloat,
        _ blue: CGFloat,
        _ opacity: CGFloat
    ) {
        self.init(
            red: red/255,
            green: green/255,
            blue: blue/255,
            opacity: opacity
        )
    }
}
