//
//  VText.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/7/21.
//

import SwiftUI

// MARK: - V Base Title
/// Core component that is used throughout the library as text.
///
///     var body: some View {
///         VText(
///             color: ColorBook.primary,
///             font: .body,
///             text: "Lorem ipsum dolor sit amet"
///         )
///     }
///
public struct VText: View {
    // MARK: Properties
    private let textType: VTextType
    private let truncatingMode: Text.TruncationMode
    private let minimumScaleFactor: CGFloat
    private let color: Color
    private let font: Font
    private let text: String
    
    // MARK: Initializers
    /// Initializes component with type, color, font, and text.
    public init(
        type textType: VTextType = .singleLine,
        truncatingMode: Text.TruncationMode = .tail,
        minimumScaleFactor: CGFloat = 0,
        color: Color,
        font: Font,
        text: String
    ) {
        self.textType = textType
        self.truncatingMode = truncatingMode
        self.minimumScaleFactor = minimumScaleFactor
        self.color = color
        self.font = font
        self.text = text
    }

    // MARK: Body
    @ViewBuilder public var body: some View {
        switch textType._textType {
        case .singleLine:
            Text(text)
                .truncationMode(truncatingMode)
                .lineLimit(1)
                .minimumScaleFactor(minimumScaleFactor)
                .foregroundColor(color)
                .font(font)
            
        case .multiLine(let alignment, let lineLimit):
            Text(text)
                .multilineTextAlignment(alignment)
                .truncationMode(truncatingMode)
                .lineLimit(lineLimit)
                .minimumScaleFactor(minimumScaleFactor)
                .foregroundColor(color)
                .font(font)
        }
    }
}

// MARK: - Preview
struct VText_Previews: PreviewProvider {
    static var previews: some View {
        VText(
            color: ColorBook.primary,
            font: .body,
            text: "Lorem ipsum dolor sit amet"
        )
    }
}
