//
//  VRollingCounterAppearance.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 25.08.23.
//

import SwiftUI
import VCore

/// Model that describes appearance.
public struct VRollingCounterAppearance {
    // MARK: Properties - Global
    /// Spacing between the components.
    public var spacing: CGFloat = 0

    /// Vertical alignment of components in horizontal layout.
    ///
    /// Baselines may result in janky animations.
    public var verticalAlignment: VerticalAlignment = .center

    // MARK: Properties - Digit Text
    /// Digit text configuration.
    public var digitTextConfiguration: TextConfiguration = .init(
        color: Color.primary,
        font: Font.body.bold()
    )

    /// Digit text margins.
    public var digitTextMargins: EdgeInsets = .init()

    /// Digit text `Y` offset relative to other components.
    public var digitTextOffsetY: CGFloat = 0

    /// Digit text increment rolling edge.
    public var digitTextIncrementRollingEdge: VerticalEdge? = .bottom

    /// Digit text decrement rolling edge.
    public var digitTextDecrementRollingEdge: VerticalEdge? = .top

    // MARK: Properties - Fraction Digits
    /// Indicates of counter has fraction digits.
    public var hasFractionDigits: Bool = true

    /// Minimum number of fraction digits.
    ///
    /// To hide fractions, set `hasFractionDigits` to `false`.
    public var minFractionDigits: Int = 2

    /// Maximum number of fraction digits.
    ///
    /// To hide fractions, set `hasFractionDigits` to `false`.
    public var maxFractionDigits: Int = 2
    
    /// Fraction digit text configuration.
    public var fractionDigitTextConfiguration: TextConfiguration = .init(
        color: Color.primary,
        font: Font.body.bold()
    )

    /// Fraction digit text margins.
    public var fractionDigitTextMargins: EdgeInsets = .init()

    /// Fraction digit text `Y` offset relative to other components.
    public var fractionDigitTextOffsetY: CGFloat = 0

    /// Fraction digit text increment rolling edge.
    public var fractionDigitTextIncrementRollingEdge: VerticalEdge? = .bottom

    /// Fraction digit text decrement rolling edge.
    public var fractionDigitTextDecrementRollingEdge: VerticalEdge? = .top

    // MARK: Properties - Grouping Separator
    /// Indicates if counter has grouping separator.
    public var hasGroupingSeparator: Bool = true

    /// Grouping separator.
    ///
    /// To hide grouping separator, set `hasGroupingSeparator` to `false`.
    public var groupingSeparator: String = ","
    
    /// Grouping separator text configuration.
    public var groupingSeparatorTextConfiguration: TextConfiguration = .init(
        color: Color.primary,
        font: Font.body.bold()
    )
    
    /// Grouping separator text margins.
    public var groupingSeparatorTextMargins: EdgeInsets = .init()

    /// Grouping separator text `Y` offset relative to other components.
    public var groupingSeparatorTextOffsetY: CGFloat = 0

    // MARK: Properties - Decimal Separator
    /// Decimal separator.
    public var decimalSeparator: String = "."

    /// Decimal separator text configuration.
    public var decimalSeparatorTextConfiguration: TextConfiguration = .init(
        color: Color.primary,
        font: Font.body.bold()
    )
    /// Decimal separator text margins.
    public var decimalSeparatorTextMargins: EdgeInsets = .init()

    /// Decimal separator text `Y` offset relative to other components.
    public var decimalSeparatorTextOffsetY: CGFloat = 0

    // MARK: Properties - Highlight
    /// Indicates if grouping separator text is highlightable.
    public var groupingSeparatorTextIsHighlightable: Bool = false

    /// Indicates if decimal separator text is highlightable.
    public var decimalSeparatorTextIsHighlightable: Bool = false

    /// Indicate if only the affected characters are highlighted.
    public var highlightsOnlyTheAffectedCharacters: Bool = true

    /// Increment highlight color.
    ///
    /// To hide highlight, set to `nil`.
    public var incrementHighlightColor: Color? = .green

    /// Decrement highlight color.
    ///
    /// To hide highlight, set to `nil`.
    public var decrementHighlightColor: Color? = .red

    // MARK: Properties - Transition - Highlight/Dehighlight
    /// Highlight and rolling animation.
    public var highlightAnimation: Animation? = .easeOut(duration: 0.25)

    /// Dehighlight animation.
    public var dehighlightAnimation: Animation? = .easeOut(duration: 0.25)

    // MARK: Initializers
    /// Initializes appearance with default values.
    public init() {}
}
