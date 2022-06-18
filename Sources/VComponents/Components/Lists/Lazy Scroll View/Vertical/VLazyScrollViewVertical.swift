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
    private let uiModel: VLazyScrollViewVerticalUIModel
    private let content: () -> Content
    
    // MARK: Initializers
    init(
        uiModel: VLazyScrollViewVerticalUIModel,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.uiModel = uiModel
        self.content = content
    }

    // MARK: Body
    var body: some View {
        ScrollView(.vertical, showsIndicators: uiModel.layout.showsIndicator, content: {
            LazyVStack(alignment: uiModel.layout.alignment, spacing: uiModel.layout.rowSpacing, content: {
                content()
            })
        })
    }
}

// MARK: - Preview
struct VLazyScrollViewVertical_Previews: PreviewProvider {
    static var previews: some View {
        VLazyScrollViewVertical(uiModel: .init(), content: {
            ForEach(0..<100, content: { num in
                Text(String(num))
            })
        })
    }
}
