//
//  VWrappingMarquee.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 24.02.23.
//

import SwiftUI
import VCore

// MARK: - V Wrapping Marquee
/// Container that automatically scrolls and wraps it's content edge-to-edge.
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

    // MARK: Properties - Sizes
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
            .overlay(marqueeContentView)
            .overlay(gradient)
            .clipped()
    }
    
    @ViewBuilder private var marqueeContentView: some View {
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
    
    @ViewBuilder private var gradient: some View {
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
        @unknown default: return offset
        }
    }
    
    private var offsetDynamicFirst: CGFloat {
        let offset: CGFloat = -(contentSize.width + uiModel.inset + uiModel.spacing/2)
        
        switch (uiModel.scrollDirection, isAnimating) {
        case (.leftToRight, false): return 0
        case (.leftToRight, true): return offset
        case (.rightToLeft, false): return offset
        case (.rightToLeft, true): return 0
        @unknown default: return offset
        }
    }
    
    private var offsetDynamicSecond: CGFloat {
        let offset: CGFloat = contentSize.width + uiModel.inset + uiModel.spacing/2
        
        switch (uiModel.scrollDirection, isAnimating) {
        case (.leftToRight, false): return offset
        case (.leftToRight, true): return 0
        case (.rightToLeft, false): return 0
        case (.rightToLeft, true): return offset
        @unknown default: return offset
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
            duration: uiModel.animationDurationType.duration(width: width),
            delay: uiModel.animationDelay
        )
        .toSwiftUIAnimation
        .repeatForever(autoreverses: false)
        .delay(uiModel.animationInitialDelay)
    }
    
    private let resettingAnimation: Animation = .linear(duration: 0)
}

// MARK: - Preview
// Developmental only
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
struct VWrappingMarquee_Previews: PreviewProvider { // Breaks for `watchOS`. Can be viewed separately.
    // Configuration
    private static var languageDirection: LayoutDirection { .leftToRight }
    private static var dynamicTypeSize: DynamicTypeSize? { nil }
    private static var colorScheme: ColorScheme { .light }
    
    // Previews
    static var previews: some View {
        Group(content: {
            Preview().previewDisplayName("*")
            InsettedContentPreview().previewDisplayName("Insetted & Gradient")
            ScrollDirectionsPreview().previewDisplayName("Scroll Directions")
        })
        .environment(\.layoutDirection, languageDirection)
        .applyIfLet(dynamicTypeSize, transform: { $0.dynamicTypeSize($1) })
        .colorScheme(colorScheme)
    }
    
    // Data
    private static func contentSmall() -> some View {
        HStack(content: {
            Image(systemName: "swift")
            
            Text("Lorem ipsum".pseudoRTL(languageDirection))
        })
        .drawingGroup()
    }
    
    private static func contentLarge() -> some View {
        HStack(content: {
            Image(systemName: "swift")
            
#if os(macOS)
            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed tristique tempor vehicula. Pellentesque habitant morbi...".pseudoRTL(languageDirection))
#elseif os(tvOS)
            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis imperdiet eros id tellus porta ullamcorper. Ut odio purus, posuere sit amet odio non, tempus scelerisque arcu. Pellentesque quis pretium erat.".pseudoRTL(languageDirection))
#else
            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit.".pseudoRTL(languageDirection))
#endif
        })
        .drawingGroup()
    }
    
    // Previews (Scenes)
    private struct Preview: View {
        var body: some View {
            PreviewContainer(content: {
                PreviewRow(
                    axis: .vertical,
                    paddedEdges: .vertical,
                    title: "Small Content",
                    content: {
                        VWrappingMarquee(
                            content: contentSmall
                        )
                    }
                )
                
                PreviewRow(
                    axis: .vertical,
                    paddedEdges: .vertical,
                    title: "Large Content",
                    content: {
                        VWrappingMarquee(
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
                        VWrappingMarquee(
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
                        VWrappingMarquee(
                            uiModel: {
                                var uiModel: VWrappingMarqueeUIModel = .init()
                                uiModel.scrollDirection = .leftToRight
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
                        VWrappingMarquee(
                            uiModel: {
                                var uiModel: VWrappingMarqueeUIModel = .init()
                                uiModel.scrollDirection = .rightToLeft
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
