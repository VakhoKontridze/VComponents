//
//  VText.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/7/21.
//

import SwiftUI

// MARK:- V Base Title
/// Core component that is used throughout the framework as text
///
/// # Usage Example #
///
/// ```
/// var body: some View {
///     VText(
///         title: "Lorem ipsum dolor sit amet",
///         color: ColorBook.primary,
///         font: .body,
///         type: .oneLine
///     )
/// }
/// ```
///
public struct VText: View {
    // MARK: Properties
    private let title: String
    private let color: Color
    private let font: Font
    private let titleType: VTextType
    
    // MARK: Initializers
    public init(
        title: String,
        color: Color,
        font: Font,
        type titleType: VTextType
    ) {
        self.title = title
        self.color = color
        self.font = font
        self.titleType = titleType
    }
}

// MARK:- Body
extension VText {
    @ViewBuilder public var body: some View {
        switch titleType {
        case .oneLine:
            Text(title)
                .lineLimit(1)
                .truncationMode(.tail)
                .foregroundColor(color)
                .font(font)
            
        case .multiLine(let limit, let alignment):
            Text(title)
                .lineLimit(limit)
                .multilineTextAlignment(alignment)
                .truncationMode(.tail)
                .foregroundColor(color)
                .font(font)
        }
    }
}

// MARK:- Preview
struct VText_Previews: PreviewProvider {
    static var previews: some View {
        VText(title: "Lorem ipsum dolor sit amet", color: ColorBook.primary, font: .body, type: .oneLine)
    }
}
