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
    private let uiModel: VLazyScrollViewHorizontalUIModel
    private let content: () -> Content
    
    // MARK: Initializers
    init(
        uiModel: VLazyScrollViewHorizontalUIModel,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.uiModel = uiModel
        self.content = content
    }

    // MARK: Body
    var body: some View {
        ScrollView(.horizontal, showsIndicators: uiModel.layout.showsIndicator, content: {
            LazyHStack(alignment: uiModel.layout.alignment, spacing: uiModel.layout.rowSpacing, content: {
                content()
            })
        })
    }
}

// MARK: - Preview
struct VLazyScrollViewHorizontal_Previews: PreviewProvider {
    static var previews: some View {
        VLazyScrollViewHorizontal(uiModel: .init(), content: {
            ForEach(0..<100, content: { num in
                Text(String(num))
            })
        })
    }
}
