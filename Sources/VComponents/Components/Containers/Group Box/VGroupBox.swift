//
//  VGroupBox.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI
import VCore

/// Container component that hosts content.
///
/// If content is passed during `init`, `VGroupBox` would resize according to the size of the content.
/// If content is not passed, `VGroupBox` would expand to occupy maximum space.
///
///     var body: some View {
///         ZStack {
///             Color(uiColor: UIColor.secondarySystemBackground)
///                 .ignoresSafeArea()
///
///             VGroupBox(appearance: .systemBackgroundColor) {
///                 Text("...")
///                     .multilineTextAlignment(.center)
///             }
///             .padding()
///         }
///     }
///
public struct VGroupBox<Content>: View where Content: View {
    // MARK: Properties - Appearance
    private let appearance: VGroupBoxAppearance
    
    @Environment(\.displayScale) private var displayScale: CGFloat
    @Environment(\.layoutDirection) private var layoutDirection: LayoutDirection

    // MARK: Properties - Content
    private let content: VGroupBoxContent<Content>
    
    // MARK: Initializers
    /// Initializes `VGroupBox`.
    public init(
        appearance: VGroupBoxAppearance = .init()
    )
        where Content == Never
    {
        self.appearance = appearance
        self.content = .empty
    }
    
    /// Initializes `VGroupBox` with content.
    public init(
        appearance: VGroupBoxAppearance = .init(),
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.appearance = appearance
        self.content = .content(content: content)
    }
    
    // MARK: Body
    public var body: some View {
        contentView
            .background { backgroundView }
            .overlay { borderView }
            .clipShape(
                .rect(
                    cornerRadii: appearance.cornerRadii
                        .horizontalCornersReversed(if:
                            appearance.reversesHorizontalCornersForRTLLanguages &&
                            layoutDirection.isRightToLeft
                        )
                )
            )
    }

    private var contentView: some View {
        Group {
            switch content {
            case .empty:
                Color.clear // `EmptyView` cannot be used as it doesn't render

            case .content(let content):
                content()
            }
        }
        .padding(appearance.contentMargins)
    }

    private var backgroundView: some View {
        appearance.backgroundColor
    }

    @ViewBuilder
    private var borderView: some View {
        let borderWidth: CGFloat = appearance.borderWidth.toPoints(scale: displayScale)

        if borderWidth > 0 {
            UnevenRoundedRectangle(
                cornerRadii: appearance.cornerRadii
                    .horizontalCornersReversed(if:
                        appearance.reversesHorizontalCornersForRTLLanguages &&
                        layoutDirection.isRightToLeft
                    )
            )
            .strokeBorder(appearance.borderColor, lineWidth: borderWidth)
        }
    }
}

#if DEBUG

#Preview("*") {
    ContentView()
}

#if !(os(macOS) || os(tvOS) || os(watchOS) || os(visionOS)) // Redundant

#Preview("System Background Color") {
    ContentView(appearance: .systemBackgroundColor, layer: .secondary)
}

#endif

private struct ContentView: View {
    // MARK: Properties
    private let appearance: VGroupBoxAppearance
    private let layer: PreviewContainerLayer

    // MARK: Initializers
    init(
        appearance: VGroupBoxAppearance = .init(),
        layer: PreviewContainerLayer = .primary
    ) {
        self.appearance = appearance
        self.layer = layer
    }

    // MARK: Body
    var body: some View {
        PreviewContainer(layer: layer) {
            VGroupBox(appearance: appearance) {
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla dapibus volutpat enim, vitae blandit justo iaculis sit amet. Aenean vitae leo tincidunt, sollicitudin mauris a, mollis massa. Sed posuere, nibh non fermentum ultrices, ipsum nunc luctus arcu, a auctor velit nisl ac nibh. Donec vel arcu condimentum, iaculis quam sed, commodo orci.")
                    .multilineTextAlignment(.center)
            }
            .padding()
        }
    }
}

#endif
