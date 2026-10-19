//
//  VWrappingMarquee.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 24.02.23.
//

import OSLog
public import SwiftUI
import VCore

/// Container component that automatically scrolls and wraps it's content edge-to-edge.
///
///     var body: some View {
///         VWrappingMarquee(
///             appearance: VWrappingMarqueeAppearance {
///                 $0.applyInsettedGradientMask()
///             }
///         ) {
///             HStack {
///                 Image(systemName: "swift")
///                 Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
///             }
///             .drawingGroup() // For `Image`
///         }
///     }
///
/// If you wish to have consistent spacing between elements, and two duplicates of marquee content,
/// `wrappedContentSpacing` property needs to be set.
///
///     var body: some View {
///         VWrappingMarquee(
///             appearance: {
///                 var appearance: VWrappingMarqueeAppearance = .init()
///                 appearance.wrappedContentSpacing = 16
///                 return appearance
///             }()
///         ) {
///             HStack(spacing: 16) {
///                 ForEach(0..<5, id: \.self) { number in
///                     Text("\(number)")
///                         .frame(dimension: 100)
///                         .background(Color.accentColor)
///                 }
///             }
///         }
///     }
///
public struct VWrappingMarquee<Content>: View where Content: View {
    // MARK: Properties - Appearance
    private let appearance: VWrappingMarqueeAppearance

    @State private var containerWidth: CGFloat = 0
    @State private var contentSize: CGSize = .zero

    // MARK: Properties - State
    private var isAnimatable: Bool {
        containerWidth > 0 && // Before measurement, a non-zero `inset` alone would pass the check below
        contentSize.width > 0 &&
        (contentSize.width + 2*appearance.inset) > containerWidth
    }

    // A `repeatForever(autoreverses:)` animation keeps its original bounds after a re-measure, leaving the copies overlapping.
    // Tying the animation to the distance it was started for restarts it whenever the distance changes.
    @State private var animatingDistance: CGFloat?
    private var isAnimating: Bool { animatingDistance == animationDistance }

    private var animationDistance: CGFloat { // Not dependent on container width
        contentSize.width +
        appearance.inset +
        appearance.wrappedContentSpacing
    }
    
    // MARK: Properties - Content
    private let content: () -> Content
    
    // MARK: Initializers
    /// Initializes `VWrappingMarquee` with content.
    public init(
        appearance: VWrappingMarqueeAppearance = .init(),
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.appearance = appearance
        self.content = content
    }
    
    // MARK: Body
    public var body: some View {
        Color.clear
            .frame(height: contentSize.height)
            .onGeometryChange(of: { $0.size.width }) { containerWidth = $0 }
            .overlay { marqueeContentView }
            .mask { gradientMask }
            .clipped() // Clips off-bound content. Also clips shadows. But, even without this, `mask(_:)` would clip shadows.
    }
    
    @ViewBuilder 
    private var marqueeContentView: some View {
        if isAnimatable {
            ZStack { // Used for additional frame
                contentView
                    .offset(x: offsetDynamicFirst)
                    .animation(isAnimating ? animation : resettingAnimation, value: isAnimating)

                contentView
                    .offset(x: offsetDynamicSecond)
                    .animation(isAnimating ? animation : resettingAnimation, value: isAnimating)
            }
            .offset(x: offsetDynamic)
            .id(animationDistance) // Discards the in-flight animation
            .task { // `onAppear(perform:)` causes UI glitches
                animatingDistance = animationDistance
            }
            
        } else {
            contentView
                .offset(x: offsetStatic)
                .onAppear { animatingDistance = nil }
        }
    }
    
    private var contentView: some View {
        content()
            .fixedSize()
            .onGeometryChange(of: { $0.size }) { contentSize = $0 }
    }
    
    @ViewBuilder
    private var gradientMask: some View {
        let isMasked: Bool =
            containerWidth > 0 && // Precondition for the layout
            appearance.gradientMaskWidth > 0 &&
            isAnimatable

        if isMasked {
            LinearGradient(
                stops: [
                    Gradient.Stop(
                        color: Color.black.opacity(appearance.gradientMaskOpacityContainerEdge),
                        location: 0
                    ),
                    Gradient.Stop(
                        color: Color.black.opacity(appearance.gradientMaskOpacityContentEdge),
                        location: appearance.gradientMaskWidth/containerWidth
                    ),
                    Gradient.Stop(
                        color: Color.black.opacity(appearance.gradientMaskOpacityContentEdge),
                        location: 1 - appearance.gradientMaskWidth/containerWidth
                    ),
                    Gradient.Stop(
                        color: Color.black.opacity(appearance.gradientMaskOpacityContainerEdge),
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
        let offset: CGFloat = (contentSize.width - containerWidth)/2 + appearance.inset
        
        switch appearance.scrollDirection {
        case .leftToRight: return offset
        case .rightToLeft: return -offset
        @unknown default:
            Logger.default.fault("Unhandled 'LayoutDirection' '\(String(describing: appearance.scrollDirection))' in 'VWrappingMarquee'")
            return 0
        }
    }
    
    private var offsetDynamicFirst: CGFloat {
        let offset: CGFloat = -(contentSize.width + appearance.inset + appearance.wrappedContentSpacing)
        
        switch (appearance.scrollDirection, isAnimating) {
        case (.leftToRight, false): return 0
        case (.leftToRight, true): return offset
        case (.rightToLeft, false): return offset
        case (.rightToLeft, true): return 0
        @unknown default:
            Logger.default.fault("Unhandled 'LayoutDirection' '\(String(describing: appearance.scrollDirection))' in 'VWrappingMarquee'")
            return 0
        }
    }
    
    private var offsetDynamicSecond: CGFloat {
        let offset: CGFloat = contentSize.width + appearance.inset + appearance.wrappedContentSpacing
        
        switch (appearance.scrollDirection, isAnimating) {
        case (.leftToRight, false): return offset
        case (.leftToRight, true): return 0
        case (.rightToLeft, false): return 0
        case (.rightToLeft, true): return offset
        @unknown default:
            Logger.default.fault("Unhandled 'LayoutDirection' '\(String(describing: appearance.scrollDirection))' in 'VWrappingMarquee'")
            return 0
        }
    }
    
    private var offsetStatic: CGFloat {
        let offset: CGFloat = (contentSize.width - containerWidth)/2 + appearance.inset
        
        switch appearance.alignmentStationary {
        case .leading: return offset
        case .center: return 0
        case .trailing: return -offset
        default:
            Logger.default.fault("Unhandled 'HorizontalAlignment' '\(String(describing: appearance.alignmentStationary))' in 'VWrappingMarquee'")
            return 0
        }
    }
    
    // MARK: Animations
    private var animation: Animation {
        BasicAnimation(
            curve: appearance.animationCurve,
            duration: appearance.animationDurationType.toDuration(width: animationDistance),
            delay: appearance.animationDelay
        )
        .toSwiftUIAnimation
        .repeatForever(autoreverses: false)
        .delay(appearance.animationInitialDelay)
    }
    
    private let resettingAnimation: Animation = .linear(duration: 0)
}

#if DEBUG

#Preview("*") {
    PreviewContainer {
        VWrappingMarquee {
            marqueeContentSmall
        }

        VWrappingMarquee {
            marqueeContent
        }

        VWrappingMarquee(
            appearance: VWrappingMarqueeAppearance { $0.applyInsettedGradientMask() }
        ) {
            marqueeContent
        }
    }
}

#Preview("Scroll Directions") {
    PreviewContainer {
        PreviewRow("Left-to-Right") {
            VWrappingMarquee(
                appearance: VWrappingMarqueeAppearance {
                    $0.scrollDirection = .leftToRight
                }
            ) {
                marqueeContent
            }
        }
    }
    
    PreviewRow("Right-to-Left") {
        VWrappingMarquee(
            appearance: VWrappingMarqueeAppearance {
                $0.scrollDirection = .rightToLeft
            }
        ) {
            marqueeContent
        }
    }
}

#endif
