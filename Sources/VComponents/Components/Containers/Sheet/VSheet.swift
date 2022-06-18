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
/// UI Model can be passed as parameter.
///
/// If content is passed during `init`, `VSheet` would resize according to the size of the content. If content is not passed, `VSheet` would expand to occupy maximum space.
///
///     var body: some View {
///         ZStack(alignment: .top, content: {
///             ColorBook.canvas.ignoresSafeArea()
///
///             VSheet(content: {
///                 VList(data: 0..<20, content: { num in
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
    private let uiModel: VSheetUIModel
    private let content: VSheetContent<Content>
    
    // MARK: Initializers
    /// Initializes component with content.
    public init(
        uiModel: VSheetUIModel = .init(),
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.uiModel = uiModel
        self.content = .content(content: content)
    }
    
    /// Initializes component.
    public init(
        uiModel: VSheetUIModel = .init()
    )
        where Content == Never
    {
        self.uiModel = uiModel
        self.content = .empty
    }

    // MARK: Body
    public var body: some View {
        contentView
            .background(sheet)
    }
    
    private var sheet: some View {
        uiModel.colors.background
            .cornerRadius(
                uiModel.layout.cornerRadius,
                corners: uiModel.layout.roundedCorners
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
            .padding(uiModel.layout.contentMargin)
    }
}

// MARK: - Preview
struct VSheet_Previews: PreviewProvider {
    static var previews: some View {
        ZStack(alignment: .top, content: {
            ColorBook.canvas.ignoresSafeArea()
            
            VSheet(content: {
                VList(data: 0..<20, content: { num in
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
