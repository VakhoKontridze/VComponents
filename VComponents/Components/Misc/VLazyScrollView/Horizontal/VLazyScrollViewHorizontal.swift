//
//  VLazyScrollViewHorizontal.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK: - V Lazy Scroll View Horizontal
struct VLazyScrollViewHorizontal<Content>: View where Content: View {
    // MARK: Properties
    private let model: VLazyScrollViewModelHorizontal
    private let content: () -> Content
    
    // MARK: Initializers
    init(
        model: VLazyScrollViewModelHorizontal,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.model = model
        self.content = content
    }

    // MARK: Body
    var body: some View {
        ScrollView(.horizontal, showsIndicators: model.misc.showIndicator, content: {
            LazyHStack(alignment: model.layout.alignment, spacing: model.layout.rowSpacing, content: {
                content()
            })
        })
    }
}

// MARK: - Preview
struct VLazyScrollViewHorizontal_Previews: PreviewProvider {
    static var previews: some View {
        VLazyScrollViewHorizontal(model: .init(), content: {
            ForEach(1..<100, content: { num in
                Text(String(num))
            })
        })
    }
}

