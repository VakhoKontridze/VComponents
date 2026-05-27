//
//  GenericStateTextConfiguration.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 22/3/26.
//

public import SwiftUI
public import VCore

/// Model that describes text configuration.
///
/// `fontWeight`, `italic`, `bold`, `monospaced`, `monospacedDigit`, and `fontDesign` are omitted.
/// Instead, configure them via `font`.
public struct GenericStateTextConfiguration<Colors> {
    // MARK: Properties - Line Type
    /// Line type.
    public var lineType: TextLineType?
    
    // MARK: Properties - Color
    /// Colors.
    public var colors: Colors?
    
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
    /// Initializes `GenericStateTextConfiguration`.
    public init(
        lineType: TextLineType? = nil,
        colors: Colors? = nil,
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
        
        self.colors = colors
        
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
    
    // MARK: Mapping
    /// Maps `GenericStateTextConfiguration` to `TextConfiguration`.
    public func toTextConfiguration(
        color: Color?
    ) -> TextConfiguration {
        .init(
            lineType: lineType,
            
            color: color,
            
            font: font,
            textCase: textCase,
            dynamicTypeSizeType: dynamicTypeSizeType,
            
            lineSpacing: lineSpacing,
            truncationMode: truncationMode,
            minimumScaleFactor: minimumScaleFactor,
            allowsTightening: allowsTightening,
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

extension View {
    /// Applies `GenericStateTextConfiguration`.
    ///
    ///     let configuration: GenericStateTextConfiguration<...> = ...
    ///
    ///     var body: some View {
    ///         Text(...)
    ///             .textConfiguration(configuration)
    ///     }
    ///
    public func textConfiguration(
        _ configuration: GenericStateTextConfiguration<
            GenericStateModel_CollapsedExpandedDisabled<Color>
        >,
        state: GenericState_CollapsedExpandedDisabled
    ) -> some View {
        self
            .textConfiguration(
                configuration.toTextConfiguration(
                    color: configuration.colors?.value(for: state)
                )
            )
    }
}

extension View {
    /// Applies `GenericStateTextConfiguration`.
    ///
    ///     let configuration: GenericStateTextConfiguration<...> = ...
    ///
    ///     var body: some View {
    ///         Text(...)
    ///             .textConfiguration(configuration)
    ///     }
    ///
    public func textConfiguration(
        _ configuration: GenericStateTextConfiguration<
            GenericStateModel_DeselectedSelectedPressedDisabled<Color>
        >,
        state: GenericState_DeselectedSelectedPressedDisabled
    ) -> some View {
        self
            .textConfiguration(
                configuration.toTextConfiguration(
                    color: configuration.colors?.value(for: state)
                )
            )
    }
}
    
extension View {
    /// Applies `GenericStateTextConfiguration`.
    ///
    ///     let configuration: GenericStateTextConfiguration<...> = ...
    ///
    ///     var body: some View {
    ///         Text(...)
    ///             .textConfiguration(configuration)
    ///     }
    ///
    public func textConfiguration(
        _ configuration: GenericStateTextConfiguration<
            GenericStateModel_EnabledPressedDisabled<Color>
        >,
        state: GenericState_EnabledPressedDisabled
    ) -> some View {
        self
            .textConfiguration(
                configuration.toTextConfiguration(
                    color: configuration.colors?.value(for: state)
                )
            )
    }
    
    /// Applies `GenericStateTextConfiguration`.
    ///
    ///     let configuration: GenericStateTextConfiguration<...> = ...
    ///
    ///     var body: some View {
    ///         Text(...)
    ///             .textConfiguration(configuration)
    ///     }
    ///
    public func textConfiguration(
        _ configuration: GenericStateTextConfiguration<
            GenericStateModel_EnabledPressedLoadingDisabled<Color>
        >,
        state: GenericState_EnabledPressedLoadingDisabled
    ) -> some View {
        self
            .textConfiguration(
                configuration.toTextConfiguration(
                    color: configuration.colors?.value(for: state)
                )
            )
    }
}

extension View {
    /// Applies `GenericStateTextConfiguration`.
    ///
    ///     let configuration: GenericStateTextConfiguration<...> = ...
    ///
    ///     var body: some View {
    ///         Text(...)
    ///             .textConfiguration(configuration)
    ///     }
    ///
    public func textConfiguration(
        _ configuration: GenericStateTextConfiguration<
            GenericStateModel_EnabledFocusedDisabled<Color>
        >,
        state: GenericState_EnabledFocusedDisabled
    ) -> some View {
        self
            .textConfiguration(
                configuration.toTextConfiguration(
                    color: configuration.colors?.value(for: state)
                )
            )
    }
}

extension View {
    /// Applies `GenericStateTextConfiguration`.
    ///
    ///     let configuration: GenericStateTextConfiguration<...> = ...
    ///
    ///     var body: some View {
    ///         Text(...)
    ///             .textConfiguration(configuration)
    ///     }
    ///
    public func textConfiguration(
        _ configuration: GenericStateTextConfiguration<
            GenericStateModel_OffOnPressedDisabled<Color>
        >,
        state: GenericState_OffOnPressedDisabled
    ) -> some View {
        self
            .textConfiguration(
                configuration.toTextConfiguration(
                    color: configuration.colors?.value(for: state)
                )
            )
    }
    
    /// Applies `GenericStateTextConfiguration`.
    ///
    ///     let configuration: GenericStateTextConfiguration<...> = ...
    ///
    ///     var body: some View {
    ///         Text(...)
    ///             .textConfiguration(configuration)
    ///     }
    ///
    public func textConfiguration(
        _ configuration: GenericStateTextConfiguration<
            GenericStateModel_OffOnIndeterminatePressedDisabled<Color>
        >,
        state: GenericState_OffOnIndeterminatePressedDisabled
    ) -> some View {
        self
            .textConfiguration(
                configuration.toTextConfiguration(
                    color: configuration.colors?.value(for: state)
                )
            )
    }
}

extension View {
    /// Applies `GenericStateTextConfiguration`.
    ///
    ///     let configuration: GenericStateTextConfiguration<...> = ...
    ///
    ///     var body: some View {
    ///         Text(...)
    ///             .textConfiguration(configuration)
    ///     }
    ///
    public func textConfiguration(
        _ configuration: GenericStateTextConfiguration<
            GenericStateModel_EnabledFocusedDisabled_EmptyFilled<Color>
        >,
        state: GenericState_EnabledFocusedDisabled_EmptyFilled
    ) -> some View {
        self
            .textConfiguration(
                configuration.toTextConfiguration(
                    color: configuration.colors?.value(for: state)
                )
            )
    }
}
