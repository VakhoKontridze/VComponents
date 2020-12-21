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
    
    private let titleColor: Color
    
    private let content: () -> Content
    
    // MARK: Initializers
    init(
        type rowType: RowType,
        titleColor: Color = .primary,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.rowType = rowType
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
                
                if case .titled(let title) = rowType {
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
            .padding(.horizontal, 10)
            .if(!rowType.isRow, transform: { $0.background(Color(red: 240/255, green: 240/255, blue: 240/255)) })
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
