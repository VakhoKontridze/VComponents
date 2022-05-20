//
//  VSheet.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI
import VCore

// MARK: - V Sheet
/// Container component that draws a background and hosts content.
///
/// Model can be passed as parameter.
///
/// If content is passed during `init`, `VSheet` would resize according to the size of the content. If content is not passed, `VSheet` would expand to occupy maximum space.
///
/// Usage example:
///
///     var body: some View {
///         ZStack(alignment: .top, content: {
///             ColorBook.canvas.ignoresSafeArea(.all, edges: .all)
///
///             VSheet(content: {
///                 VList(data: 0..<20, rowContent: { num in
///                     Text(String(num))
///                         .frame(maxWidth: .infinity, alignment: .leading)
///                 })
///             })
///                 .padding()
///         })
///     }
///
public struct VSheet<Content>: View where Content: View {
    // MARK: Properties
    private let model: VSheetModel
    private let content: VSheetContent<Content>
    
    // MARK: Initializers
    /// Initializes component with content.
    public init(
        model: VSheetModel = .init(),
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.model = model
        self.content = .content(content: content)
    }
    
    /// Initializes component.
    public init(
        model: VSheetModel = .init()
    )
        where Content == Never
    {
        self.model = model
        self.content = .empty
    }

    // MARK: Body
    public var body: some View {
        contentView
            .background(sheetView)
    }
    
    private var sheetView: some View {
        model.colors.background
            .cornerRadius(
                model.layout.cornerRadius,
                corners: model.layout.roundedCorners
            )
    }
    
    private var contentView: some View {
        Group(content: {
            switch content {
            case .empty:
                Color.clear
                
            case .content(let content):
                content()
            }
        })
            .padding(model.layout.contentMargin)
    }
}

// MARK: - Preview
struct VSheet_Previews: PreviewProvider {
    static var previews: some View {
        ZStack(alignment: .top, content: {
            ColorBook.canvasignoresSafeArea(.all, edges: .all)
            
            VSheet(content: {
                VList(data: 0..<20, rowContent: { num in
                    Text(String(num))
                        .padding(.vertical, 2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                })
            })
                .padding()
                .background(ColorBook.canvas)
        })
    }
}
