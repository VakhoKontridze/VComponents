//
//  VRollingCounterUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 25.08.23.
//

import SwiftUI
import VCore

// MARK: - Rolling Counter
/// Model that describes UI.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct VRollingCounterUIModel {
    // MARK: Properties - Global Layout
    /// Spacing between the components. Set to `0`.
    public var spacing: CGFloat = 0

    /// Vertical alignment of components in horizontal layout. Set to `center`.
    ///
    /// Baselines may result in janky animations.
    public var verticalAlignment: VerticalAlignment = .center

    // MARK: Properties - Digit Text
    /// Digit text color.
    public var digitTextColor: Color = ColorBook.primary

    /// Digit text font. Set to `bold` `body` (`17`).
    public var digitTextFont: Font = .body.bold()

    /// Digit text margins. Set to `zero`.
    public var digitTextMargins: Margins = .zero

    /// Digit text `Y` offset relative to other components. Set to `0`.
    public var digitTextOffsetY: CGFloat = 0

    /// Digit text rolling edge. Set to `top`.
    public var digitTextRollEdge: RollingEdge? = .top

    // MARK: Properties - Fraction Digits
    /// Indicates of counter has fraction digits. Set to `true`.
    public var hasFractionDigits: Bool = true

    /// Minimum number of fraction digits. Set to `2`.
    ///
    /// To hide fractions, set `hasFractionDigits` to `false`.
    public var minFractionDigits: Int = 2

    /// Maximum number of fraction digits. Set to `2`.
    ///
    /// To hide fractions, set `hasFractionDigits` to `false`.
    public var maxFractionDigits: Int = 2

    /// Fraction digit text color.
    public var fractionDigitTextColor: Color = ColorBook.primary

    /// Digit text font. Set to `bold` `body` (`17`).
    public var fractionDigitTextFont: Font = .body.bold()

    /// Fraction digit text margins. Set to `zero`.
    public var fractionDigitTextMargins: Margins = .zero

    /// Fraction digit text `Y` offset relative to other components. Set to `0`.
    public var fractionDigitTextOffsetY: CGFloat = 0

    /// Fraction digit text rolling edge. Set to `top`.
    public var fractionDigitTextRollEdge: RollingEdge? = .top

    // MARK: Properties - Grouping Separator
    /// Indicates if counter has grouping separator. Set to `true`.
    public var hasGroupingSeparator: Bool = true

    /// Grouping separator. Set to comma (`","`).
    ///
    /// To hide grouping separator, set `hasGroupingSeparator` to `false`.
    public var groupingSeparator: String = ","

    /// Grouping separator text color.
    public var groupingSeparatorTextColor: Color = ColorBook.primary

    /// Grouping separator font. Set to `bold` `body` (`17`).
    public var groupingSeparatorTextFont: Font = .body.bold()

    /// Grouping separator text margins. Set to `zero`.
    public var groupingSeparatorTextMargins: Margins = .zero

    /// Grouping separator text `Y` offset relative to other components. Set to `0`.
    public var groupingSeparatorTextOffsetY: CGFloat = 0

    // MARK: Properties - Decimal Separator
    /// Decimal separator. Set to dot (`"."`).
    public var decimalSeparator: String = "."

    /// Decimal separator text color.
    public var decimalSeparatorTextColor: Color = ColorBook.primary

    /// Decimal separator font. Set to `bold` `body` (`17`).
    public var decimalSeparatorTextFont: Font = .body.bold()

    /// Decimal separator text margins. Set to `zero`.
    public var decimalSeparatorTextMargins: Margins = .zero

    /// Decimal separator text `Y` offset relative to other components. Set to `0`.
    public var decimalSeparatorTextOffsetY: CGFloat = 0

    // MARK: Properties - Highlight
    /// Indicates if grouping separator text is highlightable. Set to `false`.
    public var groupingSeparatorTextIsHighlightable: Bool = false

    /// Indicates if decimal separator text is highlightable. Set to `false`.
    public var decimalSeparatorTextIsHighlightable: Bool = false

    /// Indicate if only the affected characters are highlighted. Set to `true`.
    public var highlightsOnlyTheAffectedCharacters: Bool = true

    /// Increment highlight color.
    ///
    /// To hide highlight, set to `nil`.
    public var incrementHighlightColor: Color? = ColorBook.accentGreen

    /// Decrement highlight color.
    ///
    /// To hide highlight, set to `nil`.
    public var decrementHighlightColor: Color? = ColorBook.accentRed

    // MARK: Properties - Transition
    /// Rolling animation. Set to `easeOut` with duration `0.25`.
    public var rollingAnimation: BasicAnimation? = .init(curve: .easeOut, duration: 0.25)

    /// Highlight animation. Set to `easeOut` with duration `0.25`.
    public var highlightAnimation: BasicAnimation? = .init(curve: .easeOut, duration: 0.25)

    /// Dehighlight animation. Set to `easeOut` with duration `0.25`.
    public var dehighlightAnimation: BasicAnimation? = .init(curve: .easeOut, duration: 0.25)

    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    /// Model that contains `leading`, `trailing`, `top`, and `bottom` margins.
    public typealias Margins = EdgeInsets_LeadingTrailingTopBottom

    // MARK: Rolling Edge
    /// Enumeration that represents rolling edge, such as `top` or `bottom`.
    public enum RollingEdge: Int, CaseIterable { // TODO: Switch to `VerticalEdge` when `iOS` `15.0` is supported
        // MARK: Cases
        /// Rolling from top edge.
        case top

        /// Rolling from bottom edge.
        case bottom

        // MARK: Properties
        var toEdge: Edge {
            switch self {
            case .top: return .top
            case .bottom: return .bottom
            }
        }
    }
}
