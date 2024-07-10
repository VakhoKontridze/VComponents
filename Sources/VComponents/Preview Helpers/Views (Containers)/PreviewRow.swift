//
//  PreviewRow.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 08.03.23.
//

#if DEBUG

import SwiftUI

// MARK: - Preview Row
struct PreviewRow<Content>: View where Content: View {
    // MARK: Properties
    private let title: String?
    private let content: () -> Content

    // MARK: Initializers
    init(
        _ title: String?,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.content = content
    }

    // MARK: Body
    var body: some View {
        VStack(
            spacing: 10,
            content: {
                if let title {
                    Text(title)
                        .lineLimit(1)
                        .foregroundStyle(Color.primary)
                        .font(.caption.bold())
                        .dynamicTypeSize(...(.accessibility2))
                }

                content()
            }
        )
    }
}

// MARK: - Preview
#Preview(body: {
    PreviewRow("Lorem Ipsum", content: {
        Text("Lorem ipsum")
    })
})

#endif
