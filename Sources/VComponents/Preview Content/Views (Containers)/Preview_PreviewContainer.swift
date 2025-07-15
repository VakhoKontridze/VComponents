//
//  Preview_PreviewContainer.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 08.03.23.
//

#if DEBUG

import SwiftUI
import VCore

// MARK: - Preview Container
struct Preview_PreviewContainer<Content>: View where Content: View {
    // MARK: Properties
    private let layer: Preview_PreviewContainerLayer
    private let content: () -> Content

    // MARK: Initializers
    init(
        layer: Preview_PreviewContainerLayer = .primary,
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

            ViewThatFits(in: .vertical) {
                vStackedContent
                
                ScrollView(.vertical) {
                    vStackedContent
                }
                .clipped()
            }
        }
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
enum Preview_PreviewContainerLayer {
    case primary
    case secondary
}

// MARK: - Preview
#Preview {
    Preview_PreviewContainer {
        Text("Lorem ipsum")
    }
}

#endif
