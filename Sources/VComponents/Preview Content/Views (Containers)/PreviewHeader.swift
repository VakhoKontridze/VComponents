//
//  PreviewHeader.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 08.03.23.
//

#if DEBUG

import SwiftUI
import VCore

// MARK: - Preview Header
struct PreviewHeader: View {
    // MARK: Properties
    private let title: String
    
    // MARK: Initializers
    init(_ title: String) {
        self.title = title
    }
    
    // MARK: Body
    var body: some View {
        HStack {
            VStack(content: Divider.init)
            
            Text(title)
                .foregroundStyle(Color.primary)
                .font(.caption.bold())
                .dynamicTypeSize(...(.accessibility2))

            VStack(content: Divider.init)
        }
        .padding(.horizontal)
    }
}

// MARK: - Preview
#Preview {
    PreviewContainer {
        PreviewRow("Lorem Ipsum") {
            Text("Lorem ipsum")
        }

        PreviewHeader("Lorem Ipsum")

        PreviewRow("Lorem Ipsum") {
            Text("Lorem ipsum")
        }
    }
}

#endif
