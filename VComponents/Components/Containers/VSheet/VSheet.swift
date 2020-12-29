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
    private let content: (() -> Content)?
    
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
        where Content == Never
    {
        self.model = model
        self.content = nil
    }
}

// MARK:- Body
public extension VSheet {
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .center), content: {
            sheetView
            contentView
        })
    }
    
    private var sheetView: some View {
        model.color
            .cornerRadius(radius: model.layout.cornerRadius, corners: model.layout.roundedCorners.uiRectCorner)
    }
    
    @ViewBuilder private var contentView: some View {
        if let content = content {
            content()
                .padding(model.layout.contentPadding)
        }
    }
}

// MARK:- Preview
struct VSheet_Previews: PreviewProvider {
    static var previews: some View {
        VSheet(content: {
            VLazyList(range: 1..<100, rowContent: { num in
                Text(String(num))
                    .padding(.vertical, 10)
            })
        })
            .padding()
            .background(ColorBook.canvas.edgesIgnoringSafeArea(.all))
    }
}
