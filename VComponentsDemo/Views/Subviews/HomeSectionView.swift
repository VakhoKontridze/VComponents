//
//  HomeSectionView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI
import VComponents

// MARK:- Home Section View
struct HomeSectionView<Content>: View where Content: View {
    // MARK: Properties
    private let title: String?
    private let content: () -> Content
    
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
extension HomeSectionView {
    var body: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            if let title = title {
                Text(title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 10)
                    .font(.system(size: 12, weight: .bold, design: .default))
                    .foregroundColor(ColorBook.primary)
            }
            
            VSheet(model: .init(layout: .init(contentPadding: 10)), content: {
                VStack(spacing: 0, content: content)
            })
        })
            .padding(.bottom, 25)
    }
}

// MARK:- Preview
struct HomeSectionView_Previews: PreviewProvider {
    static var previews: some View {
        HomeSectionView(title: "Title", content: {
            HomeRowView(title: "Subview", action: {})
        })
    }
}
