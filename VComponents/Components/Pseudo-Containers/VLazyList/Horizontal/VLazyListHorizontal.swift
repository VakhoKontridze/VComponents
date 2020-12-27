//
//  VLazyListHorizontal.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK:- V Lazy List Horizontal
struct VLazyListHorizontal<Content>: View where Content: View {
    // MARK: Properties
    private let model: VLazyListModelHorizontal
    private let content: () -> Content
    
    // MARK: Initializers
    public init(
        model: VLazyListModelHorizontal,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.model = model
        self.content = content
    }
}

// MARK:- Body
extension VLazyListHorizontal {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: model.layout.showsIndicators, content: {
            LazyHStack(alignment: model.layout.alignment, spacing: 0, content: {
                content()
            })
        })
    }
}

// MARK:- Preview
struct VLazyListHorizontal_Previews: PreviewProvider {
    static var previews: some View {
        VLazyListHorizontal(model: .init(), content: {
            ForEach(1..<100, content: { num in
                Text(String(num))
            })
        })
    }
}

