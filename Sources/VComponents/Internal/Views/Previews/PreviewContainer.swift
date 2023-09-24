//
//  PreviewContainer.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 08.03.23.
//

import SwiftUI
import VCore

// MARK: - Preview Container
struct PreviewContainer<Content>: View where Content: View {
    // MARK: Properties
    private let embeddedInScrollView: Bool
    private let hasLayer: Bool
    private let content: () -> Content
    
    // MARK: Initializers
    init(
        embeddedInScrollView: Bool = false,
        hasLayer: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.embeddedInScrollView = embeddedInScrollView
        self.hasLayer = hasLayer
        self.content = content
    }
    
    init(
        embeddedInScrollViewOnPlatforms platforms: [PreviewPlatform],
        hasLayer: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.embeddedInScrollView = platforms.contains(.currentDevice)
        self.hasLayer = hasLayer
        self.content = content
    }
    
    // MARK: Body
    var body: some View {
        ZStack(content: {
            ColorBook.secondaryBackground
                .ignoresSafeArea()
            
            if hasLayer { ColorBook.background }
            
            Group(content: {
                if embeddedInScrollView {
                    ScrollView(content: {
                        VStack(content: content)
                    })
                    .padding(.vertical, 1)
                    
                } else {
                    VStack(content: content)
                }
            })
            .applyModifier({ view in
#if os(macOS)
                view
                    .padding(.vertical, 20)
                    .previewLayout(.sizeThatFits)
#elseif os(watchOS)
                view
#else
                view
#endif
            })
        })
    }
}

// MARK: - Helpers
extension PreviewPlatform {
    static let currentDevice: Self = {
#if os(iOS)
        .iOS
#elseif os(macOS)
        .macOS
#elseif os(tvOS)
        .tvOS
#elseif os(watchOS)
        .watchOS
#endif
    }()
}

extension Axis {
    static func horizontal(
        butVerticalOnPlatforms platforms: [PreviewPlatform]
    ) -> Self {
        platforms.contains(.currentDevice) ? .vertical : .horizontal
    }
}

// MARK: - Preview
// Developmental only
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
struct PreviewContainer_Previews: PreviewProvider {
    static var previews: some View {
        PreviewContainer(content: {
            ContentView()
        })
    }
    
    struct ContentView: View {
        var body: some View {
#if os(iOS)
            VStretchedButton(
                action: {},
                title: "Lorem Ipsum"
            )
            .padding()
#else
            ColorBook.accentBlue
                .padding()
#endif
        }
    }
}
