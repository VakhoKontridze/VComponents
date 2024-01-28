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
///             uiModel: .insettedGradient,
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
public struct VWrappingMarquee<Content>: View where Content: View {
    // MARK: Properties - UI Model
    private let uiModel: VWrappingMarqueeUIModel

    // MARK: Properties - Content
    private let content: () -> Content

    // MARK: Properties - Frame
    @State private var containerWidth: CGFloat = 0
    @State private var contentSize: CGSize = .zero
    private var isAnimatable: Bool { (contentSize.width + 2*uiModel.inset) > containerWidth }

    // MARK: Properties - Flags
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
            .overlay(content: { gradientView })
            .clipped()
    }
    
    @ViewBuilder 
    private var marqueeContentView: some View {
        if isAnimatable {
            Group(content: { // `Group` is used non-stacked layout
                contentView
                    .offset(x: offsetDynamicFirst)
                    .animation(isAnimating ? animation : resettingAnimation, value: isAnimating)
                    .onAppear(perform: {
                        DispatchQueue.main.async(execute: { isAnimating = isAnimatable })
                    })
                
                contentView
                    .offset(x: offsetDynamicSecond)
                    .animation(isAnimating ? animation : resettingAnimation, value: isAnimating)
                    .onAppear(perform: {
                        DispatchQueue.main.async(execute: { isAnimating = isAnimatable })
                    })
            })
            .offset(x: offsetDynamic)
            
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
    private var gradientView: some View {
        if isAnimatable && uiModel.gradientWidth > 0 {
            HStack(spacing: 0, content: {
                LinearGradient(
                    colors: [
                        uiModel.gradientColorContainerEdge,
                        uiModel.gradientColorContentEdge
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(width: uiModel.gradientWidth)
                
                Spacer()
                
                LinearGradient(
                    colors: [
                        uiModel.gradientColorContentEdge,
                        uiModel.gradientColorContainerEdge
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(width: uiModel.gradientWidth)
            })
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
        let offset: CGFloat = -(contentSize.width + uiModel.inset + uiModel.spacing/2)
        
        switch (uiModel.scrollDirection, isAnimating) {
        case (.leftToRight, false): return 0
        case (.leftToRight, true): return offset
        case (.rightToLeft, false): return offset
        case (.rightToLeft, true): return 0
        @unknown default: fatalError()
        }
    }
    
    private var offsetDynamicSecond: CGFloat {
        let offset: CGFloat = contentSize.width + uiModel.inset + uiModel.spacing/2
        
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
            uiModel.spacing/2
        
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
            uiModel: .insettedGradient,
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
