//
//  PreviewMarqueeContent.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 21.01.24.
//

#if DEBUG

import SwiftUI

// MARK: - Preview Marquee Content (Small)
var previewMarqueeContentSmall: some View {
    HStack(content: {
        Image(systemName: "swift")
        Text("Lorem ipsum")
    })
    .drawingGroup()
}

// MARK: - Preview Marquee Content (Large)
var previewMarqueeContentLarge: some View {
    HStack(content: {
        Image(systemName: "swift")

#if os(iOS)
        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
#elseif os(macOS)
        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed tristique tempor vehicula. Pellentesque habitant morbi...")
#elseif os(tvOS)
        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis imperdiet eros id tellus porta ullamcorper. Ut odio purus, posuere sit amet odio non, tempus scelerisque arcu. Pellentesque quis pretium erat.")
#elseif os(watchOS)
        Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
#endif
    })
    .drawingGroup()
}

#endif
