//
//  PreviewContainer.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 08.03.23.
//

#if DEBUG

import SwiftUI
import VCore

struct PreviewContainer<Content>: View where Content: View {
    // MARK: Properties
    private let layer: PreviewContainerLayer
    private let content: () -> Content

    // MARK: Initializers
    init(
        layer: PreviewContainerLayer = .primary,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.layer = layer
        self.content = content
    }

    // MARK: Body
    var body: some View {
        let backgroundColor: Color = {
#if os(iOS)
            switch layer {
            case .primary: Color(uiColor: UIColor.systemBackground)
            case .secondary: Color(uiColor: UIColor.secondarySystemBackground)
            }
#else
            Color.clear
#endif
        }()
        
        return ZStack {
            backgroundColor
                .ignoresSafeArea()

            ScrollView(.vertical) {
                VStack(
                    spacing: 20,
                    content: content
                )
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity)
            }
            .clipped()
            .apply {
                if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
                    $0.defaultScrollAnchor(.center, for: .alignment)
                } else {
                    $0
                }
            }
            .scrollBounceBehavior(.basedOnSize)
        }
    }
}

nonisolated enum PreviewContainerLayer {
    case primary
    case secondary
}

#Preview {
    PreviewContainer {
        Text("Lorem ipsum")
    }
}

#endif
