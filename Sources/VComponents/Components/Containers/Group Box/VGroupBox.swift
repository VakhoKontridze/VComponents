//
//  VGroupBox.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI
import VCore

// MARK: - V Group Box
/// Container component that hosts content.
///
/// If content is passed during `init`, `VGroupBox` would resize according to the size of the content.
/// If content is not passed, `VGroupBox` would expand to occupy maximum space.
///
///     var body: some View {
///         ZStack(content: {
///             Color(uiColor: UIColor.secondarySystemBackground)
///                 .ignoresSafeArea()
///
///             VGroupBox(
///                 uiModel: .systemBackgroundColor,
///                 content: {
///                     Text("...")
///                         .multilineTextAlignment(.center)
///                 }
///             )
///             .padding()
///         })
///     }
///
public struct VGroupBox<Content>: View, Sendable where Content: View {
    // MARK: Properties - UI Model
    private let uiModel: VGroupBoxUIModel
    
    @Environment(\.displayScale) private var displayScale: CGFloat
    @Environment(\.layoutDirection) private var layoutDirection: LayoutDirection

    // MARK: Properties - Content
    private let content: VGroupBoxContent<Content>
    
    // MARK: Initializers
    /// Initializes `VGroupBox`.
    public init(
        uiModel: VGroupBoxUIModel = .init()
    )
        where Content == Never
    {
        self.uiModel = uiModel
        self.content = .empty
    }
    
    /// Initializes `VGroupBox` with content.
    public init(
        uiModel: VGroupBoxUIModel = .init(),
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.uiModel = uiModel
        self.content = .content(content: content)
    }
    
    // MARK: Body
    public var body: some View {
        contentView
            .background(content: { backgroundView })
            .overlay(content: { borderView })
            .clipShape(
                .rect(
                    cornerRadii: uiModel.cornerRadii
                        .horizontalCornersReversed(if:
                            uiModel.reversesHorizontalCornersForRTLLanguages &&
                            layoutDirection.isRightToLeft
                        )
                )
            )
    }

    private var contentView: some View {
        Group(content: {
            switch content {
            case .empty:
                Color.clear // `EmptyView` cannot be used as it doesn't render

            case .content(let content):
                content()
            }
        })
        .padding(uiModel.contentMargins)
    }

    private var backgroundView: some View {
        uiModel.backgroundColor
    }

    @ViewBuilder
    private var borderView: some View {
        let borderWidth: CGFloat = uiModel.borderWidth.toPoints(scale: displayScale)

        if borderWidth > 0 {
            UnevenRoundedRectangle(
                cornerRadii: uiModel.cornerRadii
                    .horizontalCornersReversed(if:
                        uiModel.reversesHorizontalCornersForRTLLanguages &&
                        layoutDirection.isRightToLeft
                    )
            )
            .strokeBorder(uiModel.borderColor, lineWidth: borderWidth)
        }
    }
}

// MARK: - Preview
#if DEBUG

#Preview("*", body: {
    Preview_ContentView()
})

#if !(os(macOS) || os(tvOS) || os(watchOS) || os(visionOS))

#Preview("System Background Color", body: {
    Preview_ContentView(layer: .secondary, uiModel: .systemBackgroundColor)
})

#endif

private struct Preview_ContentView: View {
    private let layer: PreviewContainerLayer
    private let uiModel: VGroupBoxUIModel

    init(
        layer: PreviewContainerLayer = .primary,
        uiModel: VGroupBoxUIModel = .init()
    ) {
        self.layer = layer
        self.uiModel = uiModel
    }

    var body: some View {
        PreviewContainer(layer: layer, content: {
            VGroupBox(
                uiModel: uiModel,
                content: {
                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla dapibus volutpat enim, vitae blandit justo iaculis sit amet. Aenean vitae leo tincidunt, sollicitudin mauris a, mollis massa. Sed posuere, nibh non fermentum ultrices, ipsum nunc luctus arcu, a auctor velit nisl ac nibh. Donec vel arcu condimentum, iaculis quam sed, commodo orci.")
                        .multilineTextAlignment(.center)
                }
            )
            .padding()
        })
    }
}

#endif
