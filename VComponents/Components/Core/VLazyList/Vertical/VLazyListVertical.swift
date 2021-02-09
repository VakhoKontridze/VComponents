//
//  VLazyListVertical.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK:- V Lazy List Vertical
struct VLazyListVertical<Content>: View where Content: View {
    // MARK: Properties
    private let model: VLazyListModelVertical
    private let content: () -> Content
    
    // MARK: Initializers
    init(
        model: VLazyListModelVertical,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.model = model
        self.content = content
    }
}

// MARK:- Body
extension VLazyListVertical {
    var body: some View {
        ScrollView(.vertical, showsIndicators: model.misc.showIndicator, content: {
            LazyVStack(alignment: model.layout.alignment, spacing: model.layout.rowSpacing, content: {
                content()
            })
        })
    }
}

// MARK:- Preview
struct VLazyListVertical_Previews: PreviewProvider {
    static var previews: some View {
        VLazyListVertical(model: .init(), content: {
            ForEach(1..<100, content: { num in
                Text(String(num))
            })
        })
    }
}
