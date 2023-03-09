//
//  PreviewRow.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 08.03.23.
//

import SwiftUI

// MARK: - Preview Row
struct PreviewRow<Content>: View where Content: View {
    // MARK: Properties
    private let axis: Axis
    private let paddedEdges: Edge.Set
    private let title: String
    private let content: () -> Content
    
    // MARK: Initializers
    init(
        axis: Axis,
        paddedEdges: Edge.Set = .all,
        title: String,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.axis = axis
        self.paddedEdges = paddedEdges
        self.title = title
        self.content = content
    }
    
    // MARK: Body
    var body: some View {
        switch axis {
        case .horizontal:
            HStack(
                spacing: 0,
                content: {
                    Text(title)
                        .frame(width: 75, alignment: .leading)
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                        .foregroundColor(ColorBook.secondary)
                        .font(.caption)
                    
                    Spacer()
                    
                    content()
                    
                    Spacer()
                }
            )
                .padding(paddedEdges)
        
        case .vertical:
            VStack(
                spacing: 10,
                content: {
                    content()
                    
                    Text(title)
                        .lineLimit(1)
                        .foregroundColor(ColorBook.secondary)
                        .font(.caption)
                }
            )
                .padding(paddedEdges)
        }
    }
}

// MARK: - Preview
struct PreviewRow_Previews: PreviewProvider {
    static var previews: some View {
        PreviewContainer(content: {
            PreviewRow(
                axis: .vertical,
                title: "Button",
                content: {
                    VPrimaryButton(
                        action: {},
                        title: "Lorem Ipsum"
                    )
                }
            )
        })
    }
}