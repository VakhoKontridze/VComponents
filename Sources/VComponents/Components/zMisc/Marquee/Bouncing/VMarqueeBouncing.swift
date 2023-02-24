//
//  VMarqueeBouncing.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 24.02.23.
//

import SwiftUI
import VCore

// MARK: - V Bouncing Marquee
struct VMarqueeBouncing<Content>: View where Content: View {
    // MARK: properties
    private let uiModel: VMarqueeBouncingUIModel
    private let content: () -> Content
    
    @State private var containerWidth: CGFloat = 0
    @State private var contentSize: CGSize = .zero
    private var isDynamic: Bool { contentSize.width > containerWidth }
    
    @State private var isAnimating: Bool = Self.isAnimatingDefault
    private static var isAnimatingDefault: Bool { false }
    
    // MARK: Initializers
    init(
        uiModel: VMarqueeBouncingUIModel,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.uiModel = uiModel
        self.content = content
    }
    
    // MARK: Body
    var body: some View {
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
                    DispatchQueue.main.async(execute: { isAnimating = containerWidth < contentSize.width })
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
        
        switch (uiModel.layout.direction, isAnimating) {
        case (.leftToRight, false): return offset
        case (.leftToRight, true): return -offset
        case (.rightToLeft, false): return -offset
        case (.rightToLeft, true): return offset
        @unknown default: return offset
        }
    }
    
    private var offsetStatic: CGFloat {
        let offset: CGFloat =  (contentSize.width - containerWidth)/2 + uiModel.layout.inset
        
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
            contentSize.width +
            2 * uiModel.layout.inset
        
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
struct VMarqueeBouncing_Previews: PreviewProvider {
    private static var shortText: String { "Lorem ipsum" }
    private static var longText: String { "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin tempus facilisis risus, ut condimentum diam tempus non." }
    
    static var previews: some View {
        VStack(spacing: 10, content: {
            VMarqueeBouncing(uiModel: .insettedGradient, content: {
                Text(shortText)
            })
            
            VMarqueeBouncing(uiModel: .insettedGradient, content: {
                HStack(content: {
                    Image(systemName: "swift")
                    Text(longText)
                })
                    .drawingGroup()
            })
        })
    }
}
