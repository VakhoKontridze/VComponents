//
//  VBouncingMarquee.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 24.02.23.
//

import SwiftUI
import VCore

// MARK: - V Bouncing Marquee
/// Container that automatically scrolls and bounces it's content edge-to-edge.
///
/// UI model can be passed as parameter.
///
///     var body: some View {
///         VMarquee(
///             uiModel: .insettedGradient,
///             content: {
///                 HStack(content: {
///                     Image(systemName: "swift")
///                     Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
///                 })
///                     .drawingGroup() // For Images
///             }
///         )
///     }
///
public struct VBouncingMarquee<Content>: View where Content: View {
    // MARK: properties
    private let uiModel: VBouncingMarqueeUIModel
    private let content: () -> Content
    
    @State private var containerWidth: CGFloat = 0
    @State private var contentSize: CGSize = .zero
    private var isDynamic: Bool { (contentSize.width + 2*uiModel.layout.inset) > containerWidth }
    
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
            .readSize(onChange: { containerWidth = $0.width })
            .overlay(content: { marqueeContentView })
            .overlay(content: { gradient })
            .clipped()
    }
    
    @ViewBuilder private var marqueeContentView: some View {
        if isDynamic {
            contentView
                .offset(x: offsetDynamic)
                .animation(animation, value: isAnimating)
                .onAppear(perform: {
                    DispatchQueue.main.async(execute: { isAnimating = isDynamic })
                })
            
        } else {
            contentView
                .offset(x: offsetStatic)
                .onAppear(perform: { isAnimating = Self.isAnimatingDefault })
        }
    }
    
    private var contentView: some View {
        content()
            .fixedSize()
            .readSize(onChange: { contentSize = $0 })
    }
    
    @ViewBuilder private var gradient: some View {
        if isDynamic && uiModel.colors.gradientWidth > 0 {
            HStack(spacing: 0, content: {
                LinearGradient(
                    colors: [
                        uiModel.colors.gradientColorContainerEdge,
                        uiModel.colors.gradientColorContentEdge
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                    .frame(width: uiModel.colors.gradientWidth)
                
                Spacer()
                
                LinearGradient(
                    colors: [
                        uiModel.colors.gradientColorContentEdge,
                        uiModel.colors.gradientColorContainerEdge
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                    .frame(width: uiModel.colors.gradientWidth)
            })
        }
    }
    
    // MARK: Offsets
    private var offsetDynamic: CGFloat {
        let offset: CGFloat = (contentSize.width - containerWidth)/2 + uiModel.layout.inset
        
        switch (uiModel.layout.scrollDirection, isAnimating) {
        case (.leftToRight, false): return offset
        case (.leftToRight, true): return -offset
        case (.rightToLeft, false): return -offset
        case (.rightToLeft, true): return offset
        @unknown default: return offset
        }
    }
    
    private var offsetStatic: CGFloat {
        let offset: CGFloat = (contentSize.width - containerWidth)/2 + uiModel.layout.inset
        
        switch uiModel.layout.alignmentStationary {
        case .leading: return offset
        case .center: return 0
        case .trailing: return -offset
        default: fatalError()
        }
    }
    
    // MARK: Animation
    private var animation: Animation {
        let width: CGFloat =
            (contentSize.width + 2*uiModel.layout.inset) -
            containerWidth
        
        return BasicAnimation(
            curve: uiModel.animations.curve,
            duration: uiModel.animations.durationType.duration(width: width)
        )
            .toSwiftUIAnimation
            .delay(uiModel.animations.delay)
            .repeatForever(autoreverses: true)
    }
}

// MARK: - Preview
struct VBouncingMarquee_Previews: PreviewProvider {
    private static func contentSmall() -> some View {
        HStack(content: {
            Image(systemName: "swift")
            Text("Lorem ipsum")
        })
            .drawingGroup()
    }
    
    private static func contentLarge() -> some View {
        HStack(content: {
            Image(systemName: "swift")
            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
        })
            .drawingGroup()
    }
    
    static var previews: some View {
        Preview().previewDisplayName("-")
        InsettedContentPreview().previewDisplayName("Insetted & Gradient")
        ScrollDirectionsPreview().previewDisplayName("Scroll Directions")
    }
    
    private struct Preview: View {
        var body: some View {
            PreviewContainer(content: {
                PreviewRow(
                    axis: .vertical,
                    paddedEdges: .vertical,
                    title: "Small Content",
                    content: {
                        VBouncingMarquee(
                            content: contentSmall
                        )
                    }
                )
                
                PreviewRow(
                    axis: .vertical,
                    paddedEdges: .vertical,
                    title: "Large Content",
                    content: {
                        VBouncingMarquee(
                            content: contentLarge
                        )
                    }
                )
            })
        }
    }
    
    private struct InsettedContentPreview: View {
        var body: some View {
            PreviewContainer(content: {
                PreviewRow(
                    axis: .vertical,
                    paddedEdges: .vertical,
                    title: "Insetted Gradient",
                    content: {
                        VBouncingMarquee(
                            uiModel: .insettedGradient,
                            content: contentLarge
                        )
                    }
                )
            })
        }
    }
    
    private struct ScrollDirectionsPreview: View {
        var body: some View {
            PreviewContainer(content: {
                PreviewRow(
                    axis: .vertical,
                    paddedEdges: .vertical,
                    title: "Left-to-Right",
                    content: {
                        VBouncingMarquee(
                            uiModel: {
                                var uiModel: VBouncingMarqueeUIModel = .init()
                                uiModel.layout.scrollDirection = .leftToRight
                                return uiModel
                            }(),
                            content: contentLarge
                        )
                    }
                )
                
                PreviewRow(
                    axis: .vertical,
                    paddedEdges: .vertical,
                    title: "Right-to-Left",
                    content: {
                        VBouncingMarquee(
                            uiModel: {
                                var uiModel: VBouncingMarqueeUIModel = .init()
                                uiModel.layout.scrollDirection = .rightToLeft
                                return uiModel
                            }(),
                            content: contentLarge
                        )
                    }
                )
            })
        }
    }
}
