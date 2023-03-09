//
//  ColorSchemePreview.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 08.03.23.
//

import SwiftUI

// MARK: - Color Scheme Preview
struct ColorSchemePreview<Content>: View where Content: View {
    // MARK: Properties
    private let title: String?
    private let content: () -> Content
    
    // MARK: Initializers
    init(
        title: String?,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.content = content
    }
    
    // MARK: Body
    var body: some View {
        content()
            .preferredColorScheme(.light)
            .previewDisplayName(formateTitle("Light"))
        
        content()
            .preferredColorScheme(.dark)
            .previewDisplayName(formateTitle("Dark"))
    }
    
    // MARK: Formatting
    private func formateTitle(_ colorScheme: String) -> String {
        if let title {
            return "\(title) (\(colorScheme))"
        } else {
            return colorScheme
        }
    }
}

// MARK: - Preview
struct ColorSchemePreview_Previews: PreviewProvider {
    static var previews: some View {
        ColorSchemePreview(title: nil, content: { PreviewContainer_Previews.previews })
    }
}
