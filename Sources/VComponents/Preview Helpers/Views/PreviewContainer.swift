//
//  PreviewContainer.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 08.03.23.
//

#if DEBUG

import SwiftUI
import VCore

// MARK: - Preview Container
struct PreviewContainer<Content>: View where Content: View {
    private let layer: PreviewContainerLayer
    private let content: () -> Content

    init(
        layer: PreviewContainerLayer = .primary,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.layer = layer
        self.content = content
    }

    var body: some View {
        ZStack(content: {
            layer.color.ignoresSafeArea()

            if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
                ViewThatFits(
                    in: .vertical,
                    content: {
                        vStackedContent

                        ScrollView(
                            .vertical,
                            content: { vStackedContent }
                        )
                        .padding(.vertical, 1) // Fixes SwiftUI `ScrollView` safe area bug
                    }
                )

            } else {
                ScrollView(
                    .vertical,
                    content: { vStackedContent }
                )
                .padding(.vertical, 1) // Fixes SwiftUI `ScrollView` safe area bug
            }
        })
    }

    private var vStackedContent: some View {
        VStack(
            spacing: 20,
            content: content
        )
        .padding(.vertical, 20)
    }
}

// MARK: - Preview Container Layer
enum PreviewContainerLayer {
    // MARK: Cases
    case primary
    case secondary

    // MARK: Properties
    var color: Color {
        switch self {
        case .primary: ColorBook.background
        case .secondary: ColorBook.secondaryBackground
        }
    }
}

// MARK: - Preview
#Preview(body: {
    PreviewContainer(content: {
        Text("Lorem ipsum")
    })
})

#endif
