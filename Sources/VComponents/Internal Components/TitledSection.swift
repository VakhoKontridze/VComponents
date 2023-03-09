//
//  TitledSection.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 17.07.22.
//

import SwiftUI

// MARK: - Titled Section
struct TitledSection<Content>: View where Content: View {
    // MARK: Properties
    private let title: String?
    private let content: () -> Content
    
    // MARK: Initializers
    init(
        title: String?,
        content: @escaping () -> Content
    ) {
        self.title = title
        self.content = content
    }
    
    // MARK: Body
    var body: some View {
        if let title {
            Section(content: content, header: { Text(title) })
        } else {
            Section(content: content)
        }
    }
}

// MARK: - Preview
struct TitledSection_Previews: PreviewProvider {
    static var previews: some View {
        VMenu_Previews.previews
    }
}
