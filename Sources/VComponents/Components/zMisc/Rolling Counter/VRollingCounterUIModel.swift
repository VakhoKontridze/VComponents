//
//  VRollingCounterUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 25.08.23.
//

import SwiftUI
import VCore

// MARK: - V Rolling Counter UI Model
/// Model that describes UI.
public struct VRollingCounterUIModel: Sendable {
    // MARK: Properties - Global
    /// Spacing between the components.
    public var spacing: CGFloat = 0

    /// Vertical alignment of components in horizontal layout.
    ///
    /// Baselines may result in janky animations.
    public var verticalAlignment: VerticalAlignment = .center

    // MARK: Properties - Digit Text
    /// Digit text color.
    public var digitTextColor: Color = .primary

    /// Digit text font.
    public var digitTextFont: Font = .body.bold()

    /// Digit text `DynamicTypeSize` type.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var digitTextDynamicTypeSizeType: DynamicTypeSizeType?

    /// Digit text margins.
    public var digitTextMargins: Margins = .zero

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

    /// Fraction digit text color.
    public var fractionDigitTextColor: Color = .primary

    /// Digit text font.
    public var fractionDigitTextFont: Font = .body.bold()

    /// Fraction digit text `DynamicTypeSize` type.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var fractionDigitTextDynamicTypeSizeType: DynamicTypeSizeType?

    /// Fraction digit text margins.
    public var fractionDigitTextMargins: Margins = .zero

    /// Fraction digit text `Y` offset relative to other components.
    public var fractionDigitTextOffsetY: CGFloat = 0

    /// Fraction digit text increment rolling edge.
    public var fractionDigitTextIncrementRollingEdge: VerticalEdge? = .bottom

    /// Fraction digit text decrement rolling edge.
    public var fractionDigitTextDecrementRollingEdge: VerticalEdge? = .top

    // MARK: Properties - Grouping Separator
    /// Indicates if counter has grouping separator.
    public var hasGroupingSeparator: Bool = true

    /// Grouping separator. Set to comma.
    ///
    /// To hide grouping separator, set `hasGroupingSeparator` to `false`.
    public var groupingSeparator: String = ","

    /// Grouping separator text color.
    public var groupingSeparatorTextColor: Color = .primary

    /// Grouping separator text font.
    public var groupingSeparatorTextFont: Font = .body.bold()

    /// Grouping separator text `DynamicTypeSize` type.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var groupingSeparatorTextDynamicTypeSizeType: DynamicTypeSizeType?

    /// Grouping separator text margins.
    public var groupingSeparatorTextMargins: Margins = .zero

    /// Grouping separator text `Y` offset relative to other components.
    public var groupingSeparatorTextOffsetY: CGFloat = 0

    // MARK: Properties - Decimal Separator
    /// Decimal separator. Set to dot.
    public var decimalSeparator: String = "."

    /// Decimal separator text color.
    public var decimalSeparatorTextColor: Color = .primary

    /// Decimal separator text font.
    public var decimalSeparatorTextFont: Font = .body.bold()

    /// Decimal separator text `DynamicTypeSize` type.
    ///
    /// Changing this property conditionally will cause view state to be reset.
    public var decimalSeparatorTextDynamicTypeSizeType: DynamicTypeSizeType?

    /// Decimal separator text margins.
    public var decimalSeparatorTextMargins: Margins = .zero

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
    public var highlightAnimation: BasicAnimation? = .init(curve: .easeOut, duration: 0.25)

    /// Dehighlight animation.
    public var dehighlightAnimation: BasicAnimation? = .init(curve: .easeOut, duration: 0.25)

    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    /// Model that contains `leading`, `trailing`, `top`, and `bottom` margins.
    public typealias Margins = EdgeInsets_LeadingTrailingTopBottom
}
