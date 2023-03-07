//
//  VMarqueesDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 24.02.23.
//

import SwiftUI
import VCore
import VComponents

// MARK: - V Marquees Demo View
struct VMarqueesDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "Marquee (Wrapping, Bouncing)" }
    
    private var shortText: String { "Lorem ipsum" }
    private var longText: String { "Lorem ipsum dolor sit amet, consectetur adipiscing elit." }
    
    @State private var marqueeStyle: VMarqueeStyleHelper = .wrapping
    @State private var scrollDirection: LayoutDirection = .leftToRight
    @State private var contentType: ContentType = .long
    @State private var insettedWithGradient: Bool = true
    
    @State private var resetAction: (() -> Void)?
 
    // MARK: Body
    var body: some View {
        DemoView(
            paddedEdges: [],
            component: component,
            settings: settings
        )
            .inlineNavigationTitle(Self.navBarTitle)
    }
    
    private func component() -> some View {
        ViewResettingContainer(content: { viewResetter in
            Group(content: {
                switch marqueeStyle {
                case .wrapping:
                    VWrappingMarquee(
                        uiModel: {
                            var uiModel: VWrappingMarqueeUIModel = insettedWithGradient ? .insettedGradient : .init()
                            uiModel.layout.scrollDirection = scrollDirection
                            return uiModel
                        }(),
                        content: { contentView }
                    )
                
                case .bouncing:
                    VBouncingMarquee(
                        uiModel: {
                            var uiModel: VBouncingMarqueeUIModel = insettedWithGradient ? .insettedGradient : .init()
                            uiModel.layout.scrollDirection = scrollDirection
                            return uiModel
                        }(),
                        content: { contentView }
                    )
                }
            })
                .onAppear(perform: { resetAction = viewResetter.trigger })
        })
    }
    
    @ViewBuilder private func settings() -> some View {
        VSegmentedPicker(selection: $marqueeStyle, headerTitle: "Style")
        
        VSegmentedPicker(selection: $scrollDirection, headerTitle: "Scroll Direction")
            .onChange(of: scrollDirection, perform: { _ in resetAction?() })
        
        VSegmentedPicker(selection: $contentType, headerTitle: "Content Type")
            .onChange(of: contentType, perform: { _ in resetAction?() })
        
        ToggleSettingView(isOn: $insettedWithGradient, title: "Insetted with Gradient")
            .onChange(of: insettedWithGradient, perform: { _ in resetAction?() })
    }
    
    private var contentView: some View {
        HStack(content: {
            Image(systemName: "swift")
                .drawingGroup()
            
            switch contentType {
            case .short: Text(shortText)
            case .long: Text(longText)
            }
        })
    }
}

// MARK: - Helpers
private enum VMarqueeStyleHelper: Int, StringRepresentableHashableEnumeration {
    case wrapping
    case bouncing
    
    var stringRepresentation: String {
        switch self {
        case .wrapping: return "Wrapping"
        case .bouncing: return "Bouncing"
        }
    }
}

extension LayoutDirection: StringRepresentableHashableEnumeration {
    public var stringRepresentation: String {
        switch self {
        case .leftToRight: return "Left-to-right"
        case .rightToLeft: return "Right-to-left"
        @unknown default: fatalError()
        }
    }
}

private enum ContentType: Int, StringRepresentableHashableEnumeration {
    case short
    case long
    
    var stringRepresentation: String {
        switch self {
        case .short: return "Short"
        case .long: return "Long"
        }
    }
}

// MARK: - Preview
struct VMarqueesDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VMarqueesDemoView()
    }
}
