//
//  VSheet.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI

// MARK:- V Sheet
public struct VSheet<Content>: View where Content: View {
    // MARK: Properties
    private let model: VSheetModel
    private let content: () -> Content
    
    // MARK: Initializers
    public init(
        model: VSheetModel = .init(),
        content: @escaping () -> Content
    ) {
        self.model = model
        self.content = content
    }

    public init(
        model: VSheetModel = .init()
    )
        where Content == Spacer
    {
        self.model = model
        self.content = { Spacer() }
    }
}

// MARK:- Body
extension VSheet {
    public var body: some View {
        contentView
            .background(sheetView)
    }
    
    private var sheetView: some View {
        model.color
            .cornerRadius(
                radius: model.layout.cornerRadius,
                corners: model.layout.roundedCorners.uiRectCorner
            )
    }
    
    private var contentView: some View {
        content()
            .padding(model.layout.contentMargin)
    }
}

// MARK:- Preview
struct VSheet_Previews: PreviewProvider {
    static var previews: some View {
        ZStack(content: {
            ColorBook.canvas
                .edgesIgnoringSafeArea(.all)
            
            VSheet(content: {
                VLazyList(range: 1..<100, rowContent: { num in
                    Text(String(num))
                        .padding(.vertical, 10)
                })
            })
                .padding()
                .background(ColorBook.canvas)
        })
    }
}
