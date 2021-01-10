//
//  VGenericTitleContent.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/7/21.
//

import SwiftUI

// MARK:- Generic Title Content View
public struct VGenericTitleContentView<S>: View where S: StringProtocol {
    // MARK: Properties
    private let title: S
    private let color: Color
    private let font: Font
    private let alignment: TextAlignment
    private let lineLimit: Int?
    
    // MARK: Initializers
    public init(
        title: S,
        color: Color,
        font: Font,
        alignment: TextAlignment = .center,
        lineLimit: Int? = 1
    ) {
        self.title = title
        self.color = color
        self.font = font
        self.alignment = alignment
        self.lineLimit = lineLimit
    }
}

// MARK:- Body
public extension VGenericTitleContentView {
    var body: some View {
        Text(title)
            .lineLimit(lineLimit)
            .multilineTextAlignment(alignment)
            .truncationMode(.tail)
            .foregroundColor(color)
            .font(font)
    }
}

// MARK:- Preview
struct VGenericTitleContentView_Previews: PreviewProvider {
    static var previews: some View {
        VGenericTitleContentView(title: "TITLE", color: ColorBook.primary, font: .body)
    }
}