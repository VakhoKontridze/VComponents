//
//  Color.MakeWithRGBA.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VCore

// MARK: - Color Make with RGBA
extension Color {
    static func make(
        _ color: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)
    ) -> Self {
        Color(red: color.r/255, green: color.g/255, blue: color.b/255, opacity: color.a)
    }

    @available(watchOS, unavailable)
    @available(visionOS, unavailable)
    static func makeDynamic(
        _ light: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat),
        _ dark: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)
    ) -> Self {
        dynamic(
            light: Color(red: light.r/255, green: light.g/255, blue: light.b/255, opacity: light.a),
            dark: Color(red: dark.r/255, green: dark.g/255, blue: dark.b/255, opacity: dark.a)
        )
    }

    static func makePlatformDynamic(
        _ light: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat),
        _ dark: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)
    ) -> Color {
        platformDynamic(
            light: Color(red: light.r/255, green: light.g/255, blue: light.b/255, opacity: light.a),
            dark: Color(red: dark.r/255, green: dark.g/255, blue: dark.b/255, opacity: dark.a)
        )
    }
}
