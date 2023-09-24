//
//  PreviewSectionHeader.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 08.03.23.
//

import SwiftUI
import VCore

// MARK: - Preview Section Header
struct PreviewSectionHeader: View {
    // MARK: Properties
    private let title: String
    
    // MARK: Initializers
    init(_ title: String) {
        self.title = title
    }
    
    // MARK: Body
    var body: some View {
        HStack(content: {
            VStack(content: Divider.init)
            
            Text(title)
                .applyModifier({
#if os(watchOS)
                    $0
                        .foregroundStyle(ColorBook.primary)
#else
                    $0
#endif
                })
                .font(.footnote)
            
            VStack(content: Divider.init)
        })
        .padding(.horizontal)
    }
}

// MARK: - Preview
// Developmental only
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
struct PreviewSectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        PreviewContainer(content: {
            PreviewRow(
                axis: .vertical,
                title: "Button",
                content: {
                    PreviewContainer_Previews.ContentView()
                }
            )
            
            PreviewSectionHeader("Section")
            
            PreviewRow(
                axis: .vertical,
                title: "Button",
                content: {
                    PreviewContainer_Previews.ContentView()
                }
            )
        })
    }
}
