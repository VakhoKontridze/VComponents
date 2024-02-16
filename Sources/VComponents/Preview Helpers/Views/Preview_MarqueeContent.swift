//
//  Preview_MarqueeContent.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 21.01.24.
//

#if DEBUG

import SwiftUI

// MARK: - Marquee Content (Small)
var preview_MarqueeContentSmall: some View {
    HStack(content: {
        Image(systemName: "swift")
        Text("Lorem ipsum")
    })
    .drawingGroup()
}

// MARK: - Marquee Content
var preview_MarqueeContent: some View {
    HStack(content: {
        Image(systemName: "swift")

#if os(iOS)
        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
#elseif os(macOS)
        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis imperdiet eros id tellus porta ullamcorper.")
#elseif os(tvOS)
        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis imperdiet eros id tellus porta ullamcorper. Ut odio purus, posuere sit amet odio non, tempus scelerisque arcu.")
#elseif os(watchOS)
        Text("Lorem ipsum dolor sit amet.")
#elseif os(visionOS)
        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis imperdiet eros id tellus porta ullamcorper. Ut odio purus, posuere sit amet odio non, tempus scelerisque arcu.")
#endif
    })
    .drawingGroup()
}

#endif
