//
//  VText.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/7/21.
//

import SwiftUI
import VCore

// MARK: - V Base Title
/// Core component that is used throughout the library as `Text`.
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
    private let textLineType: TextLineType
    private let truncatingMode: Text.TruncationMode
    private let minimumScaleFactor: CGFloat
    private let color: Color
    private let font: Font
    private let text: String
    
    // MARK: Initializers
    /// Initializes `VText` with type, color, font, and text.
    public init(
        type textLineType: TextLineType = .singleLine,
        truncatingMode: Text.TruncationMode = .tail,
        minimumScaleFactor: CGFloat = 0,
        color: Color,
        font: Font,
        text: String
    ) {
        self.textLineType = textLineType
        self.truncatingMode = truncatingMode
        self.minimumScaleFactor = minimumScaleFactor
        self.color = color
        self.font = font
        self.text = text
    }

    // MARK: Body
    public var body: some View {
        Text(text)
            .ifLet(textLineType.textAlignment, transform: { $0.multilineTextAlignment($1) })
            .lineLimit(type: textLineType.textLineLimitType)
            .truncationMode(truncatingMode)
            .minimumScaleFactor(minimumScaleFactor)
            .foregroundColor(color)
            .font(font)
    }
}

// MARK: - Preview
struct VText_Previews: PreviewProvider {
    private static var textColor: Color { ColorBook.primary }
    private static var textFont: Font { .system(size: 16) }
    
    private static var lineMin: Int { 2 }
    private static var lineMax: Int { 5 }
    
    private static var text: String { "Lorem ipsum dolor sit amet" }
    private static var textLong: String { "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla dapibus volutpat enim, vitae blandit justo iaculis sit amet." }
    
    static var previews: some View {
        ColorSchemePreview(title: nil, content: Preview.init)
        TextLineTypesPreview().previewDisplayName("Text Line Types")
    }
    
    private struct Preview: View {
        var body: some View {
            PreviewContainer(content: {
                VText(
                    color: textColor,
                    font: textFont,
                    text: text
                )
            })
        }
    }
    
    private struct TextLineTypesPreview: View {
        var body: some View {
            PreviewContainer(embeddedInScrollView: true, content: {
                PreviewRow(
                    axis: .vertical,
                    title: "Leading",
                    content: {
                        VText(
                            color: textColor,
                            font: textFont,
                            text: text
                        )
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                )
                
                PreviewRow(
                    axis: .vertical,
                    title: "Center",
                    content: {
                        VText(
                            color: textColor,
                            font: textFont,
                            text: text
                        )
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                )
                
                PreviewRow(
                    axis: .vertical,
                    title: "Trailing",
                    content: {
                        VText(
                            color: textColor,
                            font: textFont,
                            text: text
                        )
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                )
                
                PreviewRow(
                    axis: .vertical,
                    title: "Multi-Line Leading",
                    content: {
                        VText(
                            type: .multiLine(alignment: .leading, lineLimit: nil),
                            color: textColor,
                            font: textFont,
                            text: textLong
                        )
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                )
                
                PreviewRow(
                    axis: .vertical,
                    title: "Multi-Line Center",
                    content: {
                        VText(
                            type: .multiLine(alignment: .center, lineLimit: nil),
                            color: textColor,
                            font: textFont,
                            text: textLong
                        )
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                )
                
                PreviewRow(
                    axis: .vertical,
                    title: "Multi-Line Trailing",
                    content: {
                        VText(
                            type: .multiLine(alignment: .trailing, lineLimit: nil),
                            color: textColor,
                            font: textFont,
                            text: textLong
                        )
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                )
                
                if #available(iOS 16.0, *) {
                    PreviewRow(
                        axis: .vertical,
                        title: "Multi-Line Space-Reserved",
                        content: {
                            VText(
                                type: .multiLine(alignment: .center, lineLimit: lineMax, reservesSpace: true),
                                color: textColor,
                                font: textFont,
                                text: textLong
                            )
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    )
                }
                
                if #available(iOS 16.0, *) {
                    PreviewRow(
                        axis: .vertical,
                        title: "Multi-Line Partial Range (From)",
                        content: {
                            VText(
                                type: .multiLine(alignment: .center, lineLimit: lineMin...),
                                color: textColor,
                                font: textFont,
                                text: textLong
                            )
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    )
                }
                
                if #available(iOS 16.0, *) {
                    PreviewRow(
                        axis: .vertical,
                        title: "Multi-Line Partial Range (Through)",
                        content: {
                            VText(
                                type: .multiLine(alignment: .center, lineLimit: ...lineMax),
                                color: textColor,
                                font: textFont,
                                text: textLong
                            )
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    )
                }
                
                if #available(iOS 16.0, *) {
                    PreviewRow(
                        axis: .vertical,
                        title: "Multi-Line Closed Range",
                        content: {
                            VText(
                                type: .multiLine(alignment: .center, lineLimit: lineMin...lineMax),
                                color: textColor,
                                font: textFont,
                                text: textLong
                            )
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    )
                }
            })
        }
    }
}
