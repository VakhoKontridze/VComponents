//
//  VSheet.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI

// MARK:- V Sheet
/// Container component that draws a background and hosts content
///
/// Model can be passed as parameter
///
/// If content is passed during init, sheet would resize according to the size of the content. If content is not passed, sheet would expand to occupy maximum space.
///
/// # Usage Example #
///
/// ```
/// var body: some View {
///     ZStack(alignment: .top, content: {
///         ColorBook.canvas.edgesIgnoringSafeArea(.all)
///
///         VSheet(content: {
///             Image(systemName: "swift")
///                 .resizable()
///                 .frame(width: 200, height: 200)
///                 .foregroundColor(.accentColor)
///         })
///             .padding()
///     })
/// }
/// ```
///
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
        where Content == Color
    {
        self.model = model
        self.content = { Color.clear }
    }
}

// MARK:- Body
extension VSheet {
    public var body: some View {
        contentView
            .background(sheetView)
    }
    
    private var sheetView: some View {
        model.colors.background
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
                VLazyList(range: 1..<100, content: { num in
                    Text(String(num))
                        .padding(.vertical, 10)
                })
            })
                .padding()
                .background(ColorBook.canvas)
        })
    }
}
