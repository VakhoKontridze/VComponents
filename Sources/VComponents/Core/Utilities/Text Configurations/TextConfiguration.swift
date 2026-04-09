//
//  TextConfiguration.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 22/3/26.
//

import SwiftUI
import VCore

/// Model that describes text configuration.
///
/// `fontWeight`, `italic`, `bold`, `monospaced`, `monospacedDigit`, and `fontDesign` are omitted.
/// Instead, configure them via `font`.
public struct TextConfiguration {
    // MARK: Properties - Line Type
    /// Line type.
    public var lineType: TextLineType?
    
    // MARK: Properties - Color
    /// Color.
    public var color: Color?
    
    // MARK: Properties - Font
    /// Font.
    public var font: Font?
    
    /// Text case.
    public var textCase: Text.Case?
    
    /// Dynamic type size type.
    public var dynamicTypeSizeType: DynamicTypeSizeType?
    
    // MARK: Properties - Layout
    /// Line spacing.
    public var lineSpacing: CGFloat?
    
    /// Truncation mode.
    public var truncationMode: Text.TruncationMode?
    
    /// Minimum scale factor.
    public var minimumScaleFactor: CGFloat?
    
    /// Allows tightening.
    public var allowsTightening: Bool?
    
    /// Kerning.
    public var kerning: CGFloat?
    
    /// Tracking.
    public var tracking: CGFloat?
    
    /// Baseline offset.
    public var baselineOffset: CGFloat?
    
    // MARK: Properties - Misc
    /// Strike-through.
    public var strikeThrough: StrikeThrough?
    
    /// Underline.
    public var underline: Underline?
    
    // MARK: Initializers
    /// Initializes `TextConfiguration`.
    public init(
        lineType: TextLineType? = nil,
        color: Color? = nil,
        font: Font? = nil,
        textCase: Text.Case? = nil,
        dynamicTypeSizeType: DynamicTypeSizeType? = nil,
        lineSpacing: CGFloat? = nil,
        truncationMode: Text.TruncationMode? = nil,
        minimumScaleFactor: CGFloat? = nil,
        allowsTightening: Bool? = nil,
        kerning: CGFloat? = nil,
        tracking: CGFloat? = nil,
        baselineOffset: CGFloat? = nil,
        strikeThrough: StrikeThrough? = nil,
        underline: Underline? = nil
    ) {
        self.lineType = lineType
        
        self.color = color
        
        self.font = font
        self.textCase = textCase
        self.dynamicTypeSizeType = dynamicTypeSizeType
        
        self.lineSpacing = lineSpacing
        self.truncationMode = truncationMode
        self.minimumScaleFactor = minimumScaleFactor
        self.allowsTightening = allowsTightening
        self.kerning = kerning
        self.tracking = tracking
        self.baselineOffset = baselineOffset
        
        self.strikeThrough = strikeThrough
        
        self.underline = underline
    }
    
    // MARK: Types
    /// Model that describes strike-through.
    public struct StrikeThrough {
        // MARK: Properties
        /// Pattern.
        public var pattern: Text.LineStyle.Pattern
        
        /// Color.
        public var color: Color?
        
        // MARK: Initializers
        /// Initializes `StrikeThrough`.
        public init(
            pattern: Text.LineStyle.Pattern = .solid,
            color: Color? = nil
        ) {
            self.pattern = pattern
            self.color = color
        }
    }
    
    /// Model that describes underline.
    public typealias Underline = StrikeThrough
}

extension View {
    /// Applies `TextConfiguration`.
    ///
    ///     let configuration: TextConfiguration = ...
    ///
    ///     var body: some View {
    ///         Text(...)
    ///             .textConfiguration(configuration)
    ///     }
    ///
    public func textConfiguration(_ configuration: TextConfiguration) -> some View {
        self
            .multilineTextAlignment((configuration.lineType ?? .singleLine).textAlignment ?? .leading)
            .lineLimit(type: (configuration.lineType ?? .singleLine).textLineLimitType)
        
            .applyIfLet(configuration.color) { $0.foregroundStyle($1) }
        
            .font(configuration.font)
            .textCase(configuration.textCase)
            .applyIfLet(configuration.dynamicTypeSizeType) { $0.dynamicTypeSize(type: $1) }
        
            .lineSpacing(configuration.lineSpacing ?? 0)
            .truncationMode(configuration.truncationMode ?? .tail)
            .minimumScaleFactor(configuration.minimumScaleFactor ?? 1)
            .allowsTightening(configuration.allowsTightening ?? false)
            .kerning(configuration.kerning ?? 0)
            .tracking(configuration.tracking ?? 0)
            .baselineOffset(configuration.baselineOffset ?? 0)
                
            .applyIfLet(configuration.strikeThrough) { $0.strikethrough(pattern: $1.pattern, color: $1.color) }
                
            .applyIfLet(configuration.underline) { $0.underline(pattern: $1.pattern, color: $1.color) }
    }
}
