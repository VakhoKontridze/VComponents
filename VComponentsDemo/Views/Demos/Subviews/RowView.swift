//
//  RowView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 18.12.20.
//

import SwiftUI
import VComponents

// MARK:- Row View
struct RowView<Content>: View where Content: View {
    // MARK: Properties
    private let rowType: RowType
    enum RowType {
        case untitled
        case titled(_ title: String)
        case controller
        
        var isRow: Bool {
            switch self {
            case .untitled: return true
            case .titled: return true
            case .controller: return false
            }
        }
    }
    
    private let content: () -> Content
    
    // MARK: Initializers
    init(
        type rowType: RowType,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.rowType = rowType
        self.content = content
    }
}

// MARK:- Body
extension RowView {
    var body: some View {
        VStack(content: {
            VStack(spacing: 10, content: {
                content()
                
                if case .titled(let title) = rowType {
                    Text(title)
                        .font(.footnote)
                }
            })
                .padding(10)
                .padding(.top, 10)
            
            if rowType.isRow {
                Divider()
                    .padding(.horizontal, 10)
            }
        })
            .padding(.horizontal, 10)
    }
}

// MARK:- Preview
struct RowView_Previews: PreviewProvider {
    static var previews: some View {
        RowView(type: .titled("Title"), content: {
            Color.pink
                .frame(width: 100, height: 100)
        })
    }
}
