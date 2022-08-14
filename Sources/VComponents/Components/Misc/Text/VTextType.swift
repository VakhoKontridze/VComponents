//
//  VTextType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/14/21.
//

import SwiftUI

// MARK: - V Text Type
/// Model that represents text layout, such as `singleLine` or `multiLine`.
public struct VTextType {
    // MARK: Properties
    let _textType: _VTextType
    
    // MARK: Initializers
    private init(
        textType: _VTextType
    ) {
        self._textType = textType
    }
    
    /// Single-line.
    public static var singleLine: Self {
        .init(textType: .singleLine)
    }
    
    /// Multi-line.
    public static func multiLine(
        alignment: TextAlignment,
        lineLimit: Int?
    ) -> Self {
        .init(textType: .multiLine(
            alignment: alignment,
            textLineLimitType: .fixed(lineLimit: lineLimit)
        ))
    }
    
    /// Multi-line.
    public static func multiLine(
        alignment: TextAlignment,
        lineLimit: Int,
        reservesSpace: Bool
    ) -> Self {
        .init(textType: .multiLine(
            alignment: alignment,
            textLineLimitType: .spaceReserved(lineLimit: lineLimit, reservesSpace: reservesSpace)
        ))
    }
    
    /// Multi-line.
    public static func multiLine(
        alignment: TextAlignment,
        lineLimit: PartialRangeFrom<Int>
    ) -> Self {
        .init(textType: .multiLine(
            alignment: alignment,
            textLineLimitType: .partialRangeFrom(lineLimit: lineLimit)
        ))
    }
    
    /// Multi-line.
    public static func multiLine(
        alignment: TextAlignment,
        lineLimit: PartialRangeThrough<Int>
    ) -> Self {
        .init(textType: .multiLine(
            alignment: alignment,
            textLineLimitType: .partialRangeThrough(lineLimit: lineLimit)
        ))
    }
    
    /// Multi-line.
    public static func multiLine(
        alignment: TextAlignment,
        lineLimit: ClosedRange<Int>
    ) -> Self {
        .init(textType: .multiLine(
            alignment: alignment,
            textLineLimitType: .closedRange(lineLimit: lineLimit)
        ))
    }
}

// MARK: - _ V Text Type
enum _VTextType {
    // MARK: Cases
    case singleLine
    case multiLine(alignment: TextAlignment, textLineLimitType: TextLineLimitType)
    
    // MARK: Properties
    var textAlignment: TextAlignment? {
        switch self {
        case .singleLine:
            return nil
            
        case .multiLine(let alignment, _):
            return alignment
        }
    }
    
    var textLineLimitType: TextLineLimitType {
        switch self {
        case .singleLine:
            return .fixed(lineLimit: 1)
            
        case .multiLine(_, let textLineLimitType):
            return textLineLimitType
        }
    }
}

// FIXME: Remove and use VCore one when iOS 16 releases

extension View {
    func lineLimit(type: TextLineLimitType) -> some View {
        self
            .modifier(TextLineLimitViewModifier(type: type))
    }
}

enum TextLineLimitType {
    case none
    case fixed(lineLimit: Int?)
    case spaceReserved(lineLimit: Int, reservesSpace: Bool)
    case partialRangeFrom(lineLimit: PartialRangeFrom<Int>)
    case partialRangeThrough(lineLimit: PartialRangeThrough<Int>)
    case closedRange(lineLimit: ClosedRange<Int>)
}

private struct TextLineLimitViewModifier: ViewModifier {
    private let textLineLimitType: TextLineLimitType
    
    init(type textLineLimitType: TextLineLimitType) {
        self.textLineLimitType = textLineLimitType
    }
    
    func body(content: Content) -> some View {
        switch textLineLimitType {
        case .none:
            content
            
        case .fixed(let lineLimit):
            content
                .lineLimit(lineLimit)
            
        case .spaceReserved(let lineLimit, let reservesSpace):
            if #available(iOS 16, *) {
                content
                    .lineLimit(lineLimit, reservesSpace: reservesSpace)
            }
            
        case .partialRangeFrom(let lineLimit):
            if #available(iOS 16, *) {
                content
                    .lineLimit(lineLimit)
            }
            
        case .partialRangeThrough(let lineLimit):
            if #available(iOS 16, *) {
                content
                    .lineLimit(lineLimit)
            }
            
        case .closedRange(let lineLimit):
            if #available(iOS 16, *) {
                content
                    .lineLimit(lineLimit)
            }
        }
    }
}
