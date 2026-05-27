//
//  GenericStateBasicTextConfiguration.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 8/4/26.
//

public import SwiftUI
public import VCore

/// Model that describes text configuration.
///
/// `fontWeight`, `italic`, `bold`, `monospaced`, `monospacedDigit`, and `fontDesign` are omitted.
/// Instead, configure them via `font`.
public struct GenericStateBasicTextConfiguration<Colors> {
    // MARK: Properties - Color
    /// Colors.
    public var colors: Colors?
    
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
        colors: Colors? = nil,
        font: Font? = nil,
        kerning: CGFloat? = nil,
        tracking: CGFloat? = nil,
        baselineOffset: CGFloat? = nil,
        strikeThrough: StrikeThrough? = nil,
        underline: Underline? = nil
    ) {
        self.colors = colors
        
        self.font = font
        
        self.kerning = kerning
        self.tracking = tracking
        self.baselineOffset = baselineOffset
        
        self.strikeThrough = strikeThrough
        
        self.underline = underline
    }
    
    // MARK: Mapping
    /// Maps `GenericBasicTextConfiguration` to `BasicTextConfiguration`.
    public func toBasicTextConfiguration(
        color: Color?
    ) -> BasicTextConfiguration {
        .init(
            color: color,
            
            font: font,
            
            kerning: kerning,
            tracking: tracking,
            baselineOffset: baselineOffset,
            
            strikeThrough: strikeThrough,

            underline: underline
        )
    }
    
    // MARK: Types
    /// Model that describes strike-through.
    public typealias StrikeThrough = TextConfiguration.StrikeThrough
    
    /// Model that describes underline.
    public typealias Underline = TextConfiguration.Underline
}

// Needs to be extended on `Text` and to return `Text` to keep identity for `TextField`

extension Text {
    /// Applies `GenericStateTextConfiguration`.
    ///
    ///     let configuration: GenericStateBasicTextConfiguration<...> = ...
    ///
    ///     var body: some View {
    ///         Text(...)
    ///             .textConfiguration(configuration)
    ///     }
    ///
    public func textConfiguration(
        _ configuration: GenericStateBasicTextConfiguration<
            GenericStateModel_EnabledFocusedDisabled<Color>
        >,
        state: GenericState_EnabledFocusedDisabled
    ) -> Text {
        self
            .textConfiguration(
                configuration.toBasicTextConfiguration(
                    color: configuration.colors?.value(for: state)
                )
            )
    }
}
