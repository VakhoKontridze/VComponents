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
///         VBouncingMarquee(appearance: .insettedGradientMask) {
///             HStack {
///                 Image(systemName: "swift")
///                 Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
///             }
///             .drawingGroup() // For `Image`
///         }
///     }
///
public struct VBouncingMarquee<Content>: View where Content: View {
    // MARK: properties - Appearance
    private let appearance: VBouncingMarqueeAppearance
    
    @State private var containerWidth: CGFloat = 0
    @State private var contentSize: CGSize = .zero

    // MARK: properties - Content
    private let content: () -> Content

    // MARK: Properties - State
    private var isAnimatable: Bool { (contentSize.width + 2*appearance.inset) > containerWidth }
    
    @State private var isAnimating: Bool = Self.isAnimatingDefault
    private static var isAnimatingDefault: Bool { false }
    
    // MARK: Initializers
    /// Initializes `VBouncingMarquee` content.
    public init(
        appearance: VBouncingMarqueeAppearance = .init(),
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
            contentView
                .offset(x: offsetDynamic)
                .animation(animation, value: isAnimating)
                .task { @MainActor in // `onAppear(perform:)` causes UI glitches
                    isAnimating = isAnimatable
                }

        } else {
            contentView
                .offset(x: offsetStatic)
                .onAppear { isAnimating = Self.isAnimatingDefault }
        }
    }
    
    private var contentView: some View {
        content()
            .fixedSize(horizontal: true, vertical: false)
            .onGeometryChange(of: { $0.size }) { contentSize = $0 }
            .geometryGroup()
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
        
        switch (appearance.scrollDirection, isAnimating) {
        case (.leftToRight, false): return offset
        case (.leftToRight, true): return -offset
        case (.rightToLeft, false): return -offset
        case (.rightToLeft, true): return offset
        @unknown default: fatalError()
        }
    }
    
    private var offsetStatic: CGFloat {
        let offset: CGFloat = (contentSize.width - containerWidth)/2 + appearance.inset
        
        switch appearance.alignmentStationary {
        case .leading: return offset
        case .center: return 0
        case .trailing: return -offset
        default: fatalError()
        }
    }
    
    // MARK: Animations
    private var animation: Animation {
        let width: CGFloat =
            (contentSize.width + 2*appearance.inset) -
            containerWidth
        
        return BasicAnimation(
            curve: appearance.animationCurve,
            duration: appearance.animationDurationType.toDuration(width: width),
            delay: appearance.animationDelay
        )
        .toSwiftUIAnimation
        .repeatForever(autoreverses: true)
        .delay(appearance.animationInitialDelay)
    }
}

// MARK: - Preview
#if DEBUG

#Preview("*") {
    PreviewContainer {
        VBouncingMarquee {
            marqueeContentSmall
        }
        
        VBouncingMarquee {
            marqueeContent
        }
        
        VBouncingMarquee(appearance: .insettedGradientMask) {
            marqueeContent
        }
    }
}

#Preview("Scroll Directions") {
    PreviewContainer {
        PreviewRow("Left-to-Right") {
            VBouncingMarquee(
                appearance: {
                    var appearance: VBouncingMarqueeAppearance = .init()
                    appearance.scrollDirection = .leftToRight
                    return appearance
                }()
            ) {
                marqueeContent
            }
        }

        PreviewRow("Right-to-Left") {
            VBouncingMarquee(
                appearance: {
                    var appearance: VBouncingMarqueeAppearance = .init()
                    appearance.scrollDirection = .rightToLeft
                    return appearance
                }()
            ) {
                marqueeContent
            }
        }
    }
}

#endif
