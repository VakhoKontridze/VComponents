//
//  RowView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 18.12.20.
//

import SwiftUI

// MARK:- Row View
struct RowView<Content>: View where Content: View {
    // MARK: Properties
    private let title: String?
    private let titleColor: Color
    
    private let content: () -> Content
    
    // MARK: Initializers
    init(
        title: String?, titleColor: Color = .primary,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.titleColor = titleColor
        self.content = content
    }
}

// MARK:- Body
extension RowView {
    var body: some View {
        VStack(content: {
            VStack(spacing: 10, content: {
                content()
                
                if let title = title {
                    Text(title)
                        .foregroundColor(titleColor)
                        .font(.footnote)
                }
            })
                .padding(10)
                .padding(.top, 10)
            
            Divider()
                .padding(.horizontal, 10)
        })
            .id(UUID())
    }
}


// MARK:- Preview
struct RowView_Previews: PreviewProvider {
    static var previews: some View {
        RowView(title: "Title", content: {
            Color.pink
                .frame(width: 100, height: 100)
        })
    }
}
