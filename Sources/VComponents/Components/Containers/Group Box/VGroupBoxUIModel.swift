//
//  VGroupBoxUIModel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI
import VCore

// MARK: - V Group Box UI Model
/// Model that describes UI.
public struct VGroupBoxUIModel {
    // MARK: Properties - Corners
    /// Corner radii . Set to to `15`s.
    public var cornerRadii: RectangleCornerRadii = .init(15)

    /// Indicates if left and right corners should switch to support RTL languages. Set to `true`.
    public var reversesLeftAndRightCornersForRTLLanguages: Bool = true

    // MARK: Properties - Background
    /// Background color.
    public var backgroundColor: Color = {
#if os(iOS)
        Color(uiColor: UIColor.secondarySystemBackground)
#elseif os(macOS)
        Color.dynamic(Color.black.opacity(0.03), Color.black.opacity(0.15))
#elseif os(tvOS)
        Color.dynamic(Color.black.opacity(0.05), Color.white.opacity(0.1))
#elseif os(watchOS)
        Color.white.opacity(0.1)
#elseif os(visionOS)
        Color.white.opacity(0.2)
#endif
    }()

    // MARK: Properties - Content
    /// Content margins. Set to `(15, 15, 15, 15).
    public var contentMargins: Margins = .init(15)

    // MARK: Initializers
    /// Initializes UI model with default values.
    public init() {}

    // MARK: Margins
    /// Model that contains `leading`, `trailing`, `top`, and `bottom` margins.
    public typealias Margins = EdgeInsets_LeadingTrailingTopBottom
}

// MARK: - Factory
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension VGroupBoxUIModel {
    /// `VGroupBoxUIModel` with `UIColor.systemBackground` to be used on `UIColor.secondarySystemBackground`.
    public static var systemBackgroundColor: Self {
        var uiModel: Self = .init()

#if os(iOS)
        uiModel.backgroundColor = Color(uiColor: UIColor.systemBackground)
#endif

        return uiModel
    }
}
