//
//  PreviewContainer.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 08.03.23.
//

import SwiftUI

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
    
    // MARK: Body
    var body: some View {
        ZStack(content: {
            ColorBook.canvas
                .edgesIgnoringSafeArea(.all)
            
            if hasLayer { ColorBook.layer }
            
            if embeddedInScrollView {
                ScrollView(content: {
                    VStack(content: content)
                })
                    .padding(.vertical, 1)
                
            } else {
                VStack(content: content)
            }
        })
    }
}

// MARK: - Preview
struct PreviewContainer_Previews: PreviewProvider {
    static var previews: some View {
        PreviewContainer(content: {
            ContentView()
        })
    }
    
    struct ContentView: View {
        var body: some View {
#if os(iOS)
            VPrimaryButton(
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
