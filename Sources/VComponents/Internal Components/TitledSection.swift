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
    private let headerTitle: String?
    private let content: () -> Content
    
    // MARK: Initializers
    init(
        headerTitle: String?,
        content: @escaping () -> Content
    ) {
        self.headerTitle = headerTitle
        self.content = content
    }
    
    // MARK: Body
    var body: some View {
        if let headerTitle {
            Section(content: content, header: { Text(headerTitle) })
        } else {
            Section(content: content)
        }
    }
}
