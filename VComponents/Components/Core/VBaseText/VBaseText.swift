//
//  VBaseText.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/7/21.
//

import SwiftUI

// MARK:- V Base Text
public struct VBaseText: View {
    // MARK: Properties
    private let title: String
    private let color: Color
    private let font: Font
    private let alignment: TextAlignment
    private let lineLimit: Int?
    
    // MARK: Initializers
    public init(
        title: String,
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
extension VBaseText {
    public var body: some View {
        Text(title)
            .lineLimit(lineLimit)
            .multilineTextAlignment(alignment)
            .truncationMode(.tail)
            .foregroundColor(color)
            .font(font)
    }
}

// MARK:- Preview
struct VBaseText_Previews: PreviewProvider {
    static var previews: some View {
        VBaseText(title: "TITLE", color: ColorBook.primary, font: .body)
    }
}
