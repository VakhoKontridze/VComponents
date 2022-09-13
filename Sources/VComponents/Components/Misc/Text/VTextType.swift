//
//  VTextType.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/14/21.
//

// FIXME: Remove and use VCore one when iOS 16 releases

import SwiftUI

public struct TextLineType {
    public let _textLineType: _TextLineType
    
    private init(
        textLineType: _TextLineType
    ) {
        self._textLineType = textLineType
    }
    
    public static var singleLine: Self {
        .init(textLineType: .singleLine)
    }
    
    public static func multiLine(
        alignment: TextAlignment,
        lineLimit: Int?
    ) -> Self {
        .init(textLineType: .multiLine(
            alignment: alignment,
            textLineLimitType: .fixed(lineLimit: lineLimit)
        ))
    }
    
    public static func multiLine(
        alignment: TextAlignment,
        lineLimit: Int,
        reservesSpace: Bool
    ) -> Self {
        .init(textLineType: .multiLine(
            alignment: alignment,
            textLineLimitType: .spaceReserved(lineLimit: lineLimit, reservesSpace: reservesSpace)
        ))
    }
    
    public static func multiLine(
        alignment: TextAlignment,
        lineLimit: PartialRangeFrom<Int>
    ) -> Self {
        .init(textLineType: .multiLine(
            alignment: alignment,
            textLineLimitType: .partialRangeFrom(lineLimit: lineLimit)
        ))
    }
    
    public static func multiLine(
        alignment: TextAlignment,
        lineLimit: PartialRangeThrough<Int>
    ) -> Self {
        .init(textLineType: .multiLine(
            alignment: alignment,
            textLineLimitType: .partialRangeThrough(lineLimit: lineLimit)
        ))
    }
    
    public static func multiLine(
        alignment: TextAlignment,
        lineLimit: ClosedRange<Int>
    ) -> Self {
        .init(textLineType: .multiLine(
            alignment: alignment,
            textLineLimitType: .closedRange(lineLimit: lineLimit)
        ))
    }
}

public enum _TextLineType {
    case singleLine
    case multiLine(alignment: TextAlignment, textLineLimitType: TextLineLimitType)
    
    public var textAlignment: TextAlignment? {
        switch self {
        case .singleLine:
            return nil
            
        case .multiLine(let alignment, _):
            return alignment
        }
    }
    
    public var textLineLimitType: TextLineLimitType {
        switch self {
        case .singleLine:
            return .fixed(lineLimit: 1)
            
        case .multiLine(_, let textLineLimitType):
            return textLineLimitType
        }
    }
}

extension View {
    public func lineLimit(type: TextLineLimitType) -> some View {
        self
            .modifier(TextLineLimitViewModifier(type: type))
    }
}

public enum TextLineLimitType {
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
