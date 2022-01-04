//
//  VLazyScrollViewVertical.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK: - V Lazy Scroll View Vertical
struct VLazyScrollViewVertical<Content>: View where Content: View {
    // MARK: Properties
    private let model: VLazyScrollViewModelVertical
    private let content: () -> Content
    
    // MARK: Initializers
    init(
        model: VLazyScrollViewModelVertical,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.model = model
        self.content = content
    }

    // MARK: Body
    var body: some View {
        ScrollView(.vertical, showsIndicators: model.layout.showIndicator, content: {
            LazyVStack(alignment: model.layout.alignment, spacing: model.layout.rowSpacing, content: {
                content()
            })
        })
    }
}

// MARK: - Preview
struct VLazyScrollViewVertical_Previews: PreviewProvider {
    static var previews: some View {
        VLazyScrollViewVertical(model: .init(), content: {
            ForEach(1..<100, content: { num in
                Text(String(num))
            })
        })
    }
}
