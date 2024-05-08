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
            Group(content: {
#if os(iOS)
                switch layer {
                case .primary: Color(uiColor: UIColor.systemBackground)
                case .secondary: Color(uiColor: .secondarySystemBackground)
                }
#else
                Color.clear
#endif
            })
            .ignoresSafeArea()

            if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
                ViewThatFits(
                    in: .vertical,
                    content: {
                        vStackedContent

                        ScrollView(
                            .vertical,
                            content: { vStackedContent }
                        )
                        .clipped()
                    }
                )

            } else {
                ScrollView(
                    .vertical,
                    content: { vStackedContent }
                )
                .clipped()
            }
        })
    }

    private var vStackedContent: some View {
        VStack(
            spacing: 20,
            content: content
        )
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Preview Container Layer
enum PreviewContainerLayer {
    case primary
    case secondary
}

// MARK: - Preview
#Preview(body: {
    PreviewContainer(content: {
        Text("Lorem ipsum")
    })
})

#endif
