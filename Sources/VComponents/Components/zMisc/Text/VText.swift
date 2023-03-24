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
    // Configuration
    private static var colorScheme: ColorScheme { .light }

    // Previews
    static var previews: some View {
        Group(content: {
            Preview().previewDisplayName("*")
            TextLineTypesPreview().previewDisplayName("Text Line Types")
        })
            .colorScheme(colorScheme)
    }
    
    // Data
    private static var textColor: Color { ColorBook.primary }
    private static var textFont: Font {
#if os(macOS)
        return .system(size: 14, weight: .light)
#else
        return .system(size: 16)
#endif
    }
    
    private static var lineMin: Int { 2 }
    private static var lineMax: Int { 5 }
    
    private static var text: String {
#if os(watchOS)
        return "Lorem ipsum"
#else
        return "Lorem ipsum dolor sit amet"
#endif
    }
    private static var textLong: String {
#if os(tvOS)
        return "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis imperdiet eros id tellus porta ullamcorper. Ut odio purus, posuere sit amet odio non, tempus scelerisque arcu. Pellentesque quis pretium erat. Pellentesque fermentum purus varius augue auctor lacinia. In lobortis orci sed velit fermentum, eu feugiat libero bibendum. Aliquam vitae magna tincidunt, vehicula eros eget, convallis mauris. Vivamus vitae nisl in felis vehicula finibus. In quis pretium arcu. Phasellus mollis ut neque eget feugiat. Ut mattis, nisl a varius imperdiet, neque velit bibendum nisl, nec euismod nibh dui quis dolor. Maecenas posuere justo felis, tempor rutrum est sodales non. Vivamus et felis imperdiet, congue metus vitae, lobortis quam. Sed in tincidunt ex. Mauris eu auctor libero. Cras massa arcu, lobortis quis enim eu, cursus tincidunt augue. Maecenas pulvinar diam turpis, ac tristique arcu scelerisque sed."
#else
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla dapibus volutpat enim, vitae blandit justo iaculis sit amet."
#endif
    }

    // Previews (Scenes)
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
                
                if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
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
                
                if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
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
                
                if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
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
                
                if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
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
