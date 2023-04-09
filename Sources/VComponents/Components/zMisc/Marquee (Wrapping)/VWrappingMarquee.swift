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
public struct VWrappingMarquee<Content>: View where Content: View {
    // MARK: Properties
    private let uiModel: VWrappingMarqueeUIModel
    private let content: () -> Content
    
    @State private var containerWidth: CGFloat = 0
    @State private var contentSize: CGSize = .zero
    private var isDynamic: Bool { (contentSize.width + 2*uiModel.layout.inset) > containerWidth }
    
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
            .onSizeChange(perform: { containerWidth = $0.width })
            .overlay(content: { marqueeContentView })
            .overlay(content: { gradient })
            .clipped()
    }
    
    @ViewBuilder private var marqueeContentView: some View {
        if isDynamic {
            Group(content: {
                contentView
                    .offset(x: offsetDynamicFirst)
                    .animation(isAnimating ? animation : resettingAnimation, value: isAnimating)
                    .onAppear(perform: {
                        DispatchQueue.main.async(execute: { isAnimating = isDynamic })
                    })
                
                contentView
                    .offset(x: offsetDynamicSecond)
                    .animation(isAnimating ? animation : resettingAnimation, value: isAnimating)
                    .onAppear(perform: {
                        DispatchQueue.main.async(execute: { isAnimating = isDynamic })
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
            .onSizeChange(perform: { contentSize = $0 })
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
        
        switch uiModel.layout.scrollDirection {
        case .leftToRight: return offset
        case .rightToLeft: return -offset
        @unknown default: return offset
        }
    }
    
    private var offsetDynamicFirst: CGFloat {
        let offset: CGFloat = -(contentSize.width + uiModel.layout.inset + uiModel.layout.spacing/2)
        
        switch (uiModel.layout.scrollDirection, isAnimating) {
        case (.leftToRight, false): return 0
        case (.leftToRight, true): return offset
        case (.rightToLeft, false): return offset
        case (.rightToLeft, true): return 0
        @unknown default: return offset
        }
    }
    
    private var offsetDynamicSecond: CGFloat {
        let offset: CGFloat = contentSize.width + uiModel.layout.inset + uiModel.layout.spacing/2
        
        switch (uiModel.layout.scrollDirection, isAnimating) {
        case (.leftToRight, false): return offset
        case (.leftToRight, true): return 0
        case (.rightToLeft, false): return 0
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
    
    // MARK: Animations
    private var animation: Animation {
        let width: CGFloat = // Not dependent on container width
            contentSize.width +
            uiModel.layout.inset +
            uiModel.layout.spacing/2
        
        return BasicAnimation(
            curve: uiModel.animations.curve,
            duration: uiModel.animations.durationType.duration(width: width)
        )
            .toSwiftUIAnimation
            .delay(uiModel.animations.delay)
            .repeatForever(autoreverses: false)
    }
    
    private let resettingAnimation: Animation = .linear(duration: 0)
}

// MARK: - Preview
struct VWrappingMarquee_Previews: PreviewProvider {
    private static var shortText: String { "Lorem ipsum" }
    private static var longText: String { "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin tempus facilisis risus, ut condimentum diam tempus non." }
    
    static var previews: some View {
        VStack(spacing: 10, content: {
            VWrappingMarquee(uiModel: .insettedGradient, content: {
                Text(shortText)
            })
            
            VWrappingMarquee(uiModel: .insettedGradient, content: {
                HStack(content: {
                    Image(systemName: "swift")
                    Text(longText)
                })
                    .drawingGroup()
            })
        })
    }
}
