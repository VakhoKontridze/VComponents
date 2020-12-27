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
    private let sheetType: VSheetType
    private let content: (() -> Content)?
    
    // MARK: Initializers
    public init(
        _ sheetType: VSheetType = .default,
        content: @escaping () -> Content
    ) {
        self.sheetType = sheetType
        self.content = content
    }

    public init(
        _ sheetType: VSheetType = .default
    )
        where Content == Never
    {
        self.sheetType = sheetType
        self.content = nil
    }
}

// MARK:- Body
public extension VSheet {
    @ViewBuilder var body: some View {
        switch sheetType {
        case .roundAll(let model):
            view(
                corners: .allCorners,
                radius: model.layout.radius,
                contentPadding: model.layout.contentPadding,
                backgroundColor: model.colors.background
            )
        
        case .roundTop(let model):
            view(
                corners: [.topLeft, .topRight],
                radius: model.layout.radius,
                contentPadding: model.layout.contentPadding,
                backgroundColor: model.colors.background
            )
        
        case .roundBottom(let model):
            view(
                corners: [.bottomLeft, .bottomRight],
                radius: model.layout.radius,
                contentPadding: model.layout.contentPadding,
                backgroundColor: model.colors.background
            )
        
        case .roundCustom(let model):
            view(
                corners: model.layout.corners,
                radius: model.layout.radius,
                contentPadding: model.layout.contentPadding,
                backgroundColor: model.colors.background
            )
        }
    }
    
    func view(corners: UIRectCorner, radius: CGFloat, contentPadding: CGFloat, backgroundColor: Color) -> some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .center), content: {
            backgroundColor
                .cornerRadius(radius: radius, corners: corners)
            
            content?()
                .padding(contentPadding)
        })
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
