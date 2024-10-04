//
//  VBouncingMarquee.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 24.02.23.
//

import SwiftUI
import VCore

// MARK: - V Bouncing Marquee
/// Container component that automatically scrolls and bounces it's content edge-to-edge.
///
///     var body: some View {
///         VBouncingMarquee(
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
public struct VBouncingMarquee<Content>: View where Content: View {
    // MARK: properties - UI Model
    private let uiModel: VBouncingMarqueeUIModel
    
    @State private var containerWidth: CGFloat = 0
    @State private var contentSize: CGSize = .zero

    // MARK: properties - Content
    private let content: () -> Content

    // MARK: Properties - Flags
    private var isAnimatable: Bool { (contentSize.width + 2*uiModel.inset) > containerWidth }
    
    @State private var isAnimating: Bool = Self.isAnimatingDefault
    private static var isAnimatingDefault: Bool { false }
    
    // MARK: Initializers
    /// Initializes `VBouncingMarquee` content.
    public init(
        uiModel: VBouncingMarqueeUIModel = .init(),
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
            .clipped() // Clips off-bound content
    }
    
    @ViewBuilder 
    private var marqueeContentView: some View {
        if isAnimatable {
            contentView
                .offset(x: offsetDynamic)
                .animation(animation, value: isAnimating)
                .task({ isAnimating = isAnimatable })

        } else {
            contentView
                .offset(x: offsetStatic)
                .onAppear(perform: { isAnimating = Self.isAnimatingDefault })
        }
    }
    
    private var contentView: some View {
        content()
            .fixedSize(horizontal: true, vertical: false)
            .getSize({ contentSize = $0 })
            .applyModifier({
                if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
                    $0
                        .geometryGroup()
                } else {
                    $0
                }
            })
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
        
        switch (uiModel.scrollDirection, isAnimating) {
        case (.leftToRight, false): return offset
        case (.leftToRight, true): return -offset
        case (.rightToLeft, false): return -offset
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
        let width: CGFloat =
            (contentSize.width + 2*uiModel.inset) -
            containerWidth
        
        return BasicAnimation(
            curve: uiModel.animationCurve,
            duration: uiModel.animationDurationType.toDuration(width: width),
            delay: uiModel.animationDelay
        )
        .toSwiftUIAnimation
        .repeatForever(autoreverses: true)
        .delay(uiModel.animationInitialDelay)
    }
}

// MARK: - Preview
#if DEBUG

#Preview("*", body: {
    PreviewContainer(content: {
        VBouncingMarquee(
            content: { preview_MarqueeContentSmall }
        )

        VBouncingMarquee(
            content: { preview_MarqueeContent }
        )

        VBouncingMarquee(
            uiModel: .insettedGradientMask,
            content: { preview_MarqueeContent }
        )
    })
})

#Preview("Scroll Directions", body: {
    PreviewContainer(content: {
        PreviewRow("Left-to-Right", content: {
            VBouncingMarquee(
                uiModel: {
                    var uiModel: VBouncingMarqueeUIModel = .init()
                    uiModel.scrollDirection = .leftToRight
                    return uiModel
                }(),
                content: { preview_MarqueeContent }
            )
        })

        PreviewRow("Right-to-Left", content: {
            VBouncingMarquee(
                uiModel: {
                    var uiModel: VBouncingMarqueeUIModel = .init()
                    uiModel.scrollDirection = .rightToLeft
                    return uiModel
                }(),
                content: { preview_MarqueeContent }
            )
        })
    })
})

#endif
