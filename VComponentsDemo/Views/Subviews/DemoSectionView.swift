//
//  HomeSectionView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI
import VComponents

// MARK:- Demo Section View
struct DemoSectionView<Content>: View where Content: View {
    // MARK: Properties
    private let title: String?
    private let content: () -> Content
    
    private let sheetModel: VSheetModel = {
        var model: VSheetModel = .init()
        model.layout.contentMargin = 10
        return model
    }()
    
    // MARK: Initializers
    init(
        title: String?,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.content = content
    }
}

// MARK:- Body
extension DemoSectionView {
    var body: some View {
        ScrollView(content: {
            VStack(alignment: .leading, spacing: 10, content: {
                if let title = title, !title.isEmpty {
                    Text(title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 10)
                        .font(.system(size: 12, weight: .bold, design: .default))
                        .foregroundColor(ColorBook.primary)
                }
                
                VSheet(model: sheetModel, content: {
                    VStack(spacing: 0, content: content)
                })
            })
                .padding(.bottom, 20)
        })
            .padding(.vertical, 1)  // ScrollView is bugged in SwiftUI 2.0
    }
}

// MARK:- Preview
struct DemoSectionView_Previews: PreviewProvider {
    static var previews: some View {
        DemoSectionView(title: "Title", content: {
            DemoListRowView(title: "Subview", action: {})
        })
    }
}
