//
//  VWrappingMarquee.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 24.02.23.
//

import SwiftUI
import VCore

// MARK: - V Wrapping Marquee
/// Container component that automatically scrolls and wraps it's content edge-to-edge.
///
///     var body: some View {
///         VWrappingMarquee(
///             uiModel: .insettedGradientMask,
///             content: {
///                 HStack(content: {
///                     Image(systemName: "swift")
///                     Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
///                 })
///                 .drawingGroup() // For `Image`
///             }
///         )
///     }
///
/// If you wish to have consistent spacing between elements, and two duplicates of marquee content,
/// `wrappedContentSpacing` property needs to be set.
///
///     var body: some View {
///         VWrappingMarquee(
///             uiModel: {
///                 var uiModel: VWrappingMarqueeUIModel = .init()
///                 uiModel.wrappedContentSpacing = 16
///                 return uiModel
///             }(),
///             content: {
///                 HStack(spacing: 16, content: {
///                     ForEach(0..<5, id: \.self, content: { i in
///                         Text("\(i)")
///                             .frame(dimension: 100)
///                             .background(content: { Color.accentColor })
///                     })
///                 })
///             }
///         )
///     }
///
public struct VWrappingMarquee<Content>: View, Sendable where Content: View {
    // MARK: Properties - UI Model
    private let uiModel: VWrappingMarqueeUIModel

    @State private var containerWidth: CGFloat = 0
    @State private var contentSize: CGSize = .zero
    
    // MARK: Properties - Content
    private let content: () -> Content

    // MARK: Properties - Flags
    private var isAnimatable: Bool { (contentSize.width + 2*uiModel.inset) > containerWidth }
    
    @State private var isAnimating: Bool = Self.isAnimatingDefault
    private static var isAnimatingDefault: Bool { false }
    
    // MARK: Initializers
    /// Initializes `VWrappingMarquee` with content.
    public init(
        uiModel: VWrappingMarqueeUIModel = .init(),
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.uiModel = uiModel
        self.content = content
    }
    
    // MARK: Body
    public var body: some View {
        Color.clear
            .frame(height: contentSize.height)
            .getSize({ containerWidth = $0.width })
            .overlay(content: { marqueeContentView })
            .mask({ gradientMask })
            .clipped() // Clips off-bound content. Also clips shadows. But, even without this, `mask(_:)` would clip shadows.
    }
    
    @ViewBuilder 
    private var marqueeContentView: some View {
        if isAnimatable {
            Group(content: { // `Group` is used for non-stacked layout
                contentView
                    .offset(x: offsetDynamicFirst)
                    .animation(isAnimating ? animation : resettingAnimation, value: isAnimating)

                contentView
                    .offset(x: offsetDynamicSecond)
                    .animation(isAnimating ? animation : resettingAnimation, value: isAnimating)
            })
            .offset(x: offsetDynamic)
            .task({ isAnimating = isAnimatable }) // `onAppear(perform:)` causes UI glitches
            
        } else {
            contentView
                .offset(x: offsetStatic)
                .onAppear(perform: { isAnimating = Self.isAnimatingDefault })
        }
    }
    
    private var contentView: some View {
        content()
            .fixedSize()
            .getSize({ contentSize = $0 })
    }
    
    @ViewBuilder
    private var gradientMask: some View {
        let isMasked: Bool =
            containerWidth > 0 && // Precondition for the layout
            uiModel.gradientMaskWidth > 0 &&
            isAnimatable

        if isMasked {
            LinearGradient(
                stops: [
                    Gradient.Stop(
                        color: Color.black.opacity(uiModel.gradientMaskOpacityContainerEdge),
                        location: 0
                    ),
                    Gradient.Stop(
                        color: Color.black.opacity(uiModel.gradientMaskOpacityContentEdge),
                        location: uiModel.gradientMaskWidth/containerWidth
                    ),
                    Gradient.Stop(
                        color: Color.black.opacity(uiModel.gradientMaskOpacityContentEdge),
                        location: 1 - uiModel.gradientMaskWidth/containerWidth
                    ),
                    Gradient.Stop(
                        color: Color.black.opacity(uiModel.gradientMaskOpacityContainerEdge),
                        location: 1
                    )
                ],
                startPoint: .leading,
                endPoint: .trailing
            )

        } else {
            Color.black
        }
    }

    // MARK: Offsets
    private var offsetDynamic: CGFloat {
        let offset: CGFloat = (contentSize.width - containerWidth)/2 + uiModel.inset
        
        switch uiModel.scrollDirection {
        case .leftToRight: return offset
        case .rightToLeft: return -offset
        @unknown default: fatalError()
        }
    }
    
    private var offsetDynamicFirst: CGFloat {
        let offset: CGFloat = -(contentSize.width + uiModel.inset + uiModel.wrappedContentSpacing)
        
        switch (uiModel.scrollDirection, isAnimating) {
        case (.leftToRight, false): return 0
        case (.leftToRight, true): return offset
        case (.rightToLeft, false): return offset
        case (.rightToLeft, true): return 0
        @unknown default: fatalError()
        }
    }
    
    private var offsetDynamicSecond: CGFloat {
        let offset: CGFloat = contentSize.width + uiModel.inset + uiModel.wrappedContentSpacing
        
        switch (uiModel.scrollDirection, isAnimating) {
        case (.leftToRight, false): return offset
        case (.leftToRight, true): return 0
        case (.rightToLeft, false): return 0
        case (.rightToLeft, true): return offset
        @unknown default: fatalError()
        }
    }
    
    private var offsetStatic: CGFloat {
        let offset: CGFloat = (contentSize.width - containerWidth)/2 + uiModel.inset
        
        switch uiModel.alignmentStationary {
        case .leading: return offset
        case .center: return 0
        case .trailing: return -offset
        default: fatalError()
        }
    }
    
    // MARK: Animations
    private var animation: Animation {
        let width: CGFloat = // Not dependent on container width
            contentSize.width +
            uiModel.inset +
            uiModel.wrappedContentSpacing
        
        return BasicAnimation(
            curve: uiModel.animationCurve,
            duration: uiModel.animationDurationType.toDuration(width: width),
            delay: uiModel.animationDelay
        )
        .toSwiftUIAnimation
        .repeatForever(autoreverses: false)
        .delay(uiModel.animationInitialDelay)
    }
    
    private let resettingAnimation: Animation = .linear(duration: 0)
}

// MARK: - Preview
#if DEBUG

#Preview("*", body: {
    PreviewContainer(content: {
        VWrappingMarquee(
            content: { preview_MarqueeContentSmall }
        )

        VWrappingMarquee(
            content: { preview_MarqueeContent }
        )

        VWrappingMarquee(
            uiModel: .insettedGradientMask,
            content: { preview_MarqueeContent }
        )
    })
})

#Preview("Scroll Directions", body: {
    PreviewContainer(content: {
        PreviewRow("Left-to-Right", content: {
            VWrappingMarquee(
                uiModel: {
                    var uiModel: VWrappingMarqueeUIModel = .init()
                    uiModel.scrollDirection = .leftToRight
                    return uiModel
                }(),
                content: { preview_MarqueeContent }
            )
        })

        PreviewRow("Right-to-Left", content: {
            VWrappingMarquee(
                uiModel: {
                    var uiModel: VWrappingMarqueeUIModel = .init()
                    uiModel.scrollDirection = .rightToLeft
                    return uiModel
                }(),
                content: { preview_MarqueeContent }
            )
        })
    })
})

#endif
