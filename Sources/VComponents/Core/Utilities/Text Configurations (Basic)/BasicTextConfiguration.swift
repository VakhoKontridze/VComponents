//
//  BasicTextConfiguration.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 8/4/26.
//

public import SwiftUI

/// Model that describes text configuration.
///
/// `fontWeight`, `italic`, `bold`, `monospaced`, `monospacedDigit`, and `fontDesign` are omitted.
/// Instead, configure them via `font`.
public struct BasicTextConfiguration {
    // MARK: Properties - Color
    /// Color.
    public var color: Color?
    
    // MARK: Properties - Font
    /// Font.
    public var font: Font?
    
    // MARK: Properties - Layout
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
        color: Color? = nil,
        font: Font? = nil,
        kerning: CGFloat? = nil,
        tracking: CGFloat? = nil,
        baselineOffset: CGFloat? = nil,
        strikeThrough: StrikeThrough? = nil,
        underline: Underline? = nil
    ) {
        self.color = color
        
        self.font = font
        
        self.kerning = kerning
        self.tracking = tracking
        self.baselineOffset = baselineOffset
        
        self.strikeThrough = strikeThrough
        
        self.underline = underline
    }
    
    // MARK: Types
    /// Model that describes strike-through.
    public typealias StrikeThrough = TextConfiguration.StrikeThrough
    
    /// Model that describes underline.
    public typealias Underline = TextConfiguration.Underline
}

// Needs to be extended on `Text` and to return `Text` to keep identity for `TextField`

extension Text {
    /// Applies `TextConfiguration`.
    ///
    ///     let configuration: BasicTextConfiguration = ...
    ///
    ///     var body: some View {
    ///         Text(...)
    ///             .textConfiguration(configuration)
    ///     }
    ///
    public func textConfiguration(_ configuration: BasicTextConfiguration) -> Text {
        self
            .applyIfLet_Text(configuration.color) { $0.foregroundStyle($1) }
        
            .font(configuration.font)

            .kerning(configuration.kerning ?? 0)
            .tracking(configuration.tracking ?? 0)
            .baselineOffset(configuration.baselineOffset ?? 0)
                
            .applyIfLet_Text(configuration.strikeThrough) { $0.strikethrough(pattern: $1.pattern, color: $1.color) }
                
            .applyIfLet_Text(configuration.underline) { $0.underline(pattern: $1.pattern, color: $1.color) }
    }
}

nonisolated extension Text {
    fileprivate func applyIfLet_Text<Value>(
        _ value: Value?,
        transform: (Self, Value) -> Text
    ) -> Text {
        if let value {
            transform(self, value)
        } else {
            self
        }
    }
}
