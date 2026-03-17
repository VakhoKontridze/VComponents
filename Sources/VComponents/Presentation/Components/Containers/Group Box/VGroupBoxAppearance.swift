//
//  VGroupBoxAppearance.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI
import VCore

/// Model that describes appearance.
public struct VGroupBoxAppearance {
    // MARK: Properties - Corners
    /// Corner radii.
    public var cornerRadii: RectangleCornerRadii = {
#if os(iOS)
        RectangleCornerRadii(15)
#elseif os(macOS)
        RectangleCornerRadii(7.5)
#elseif os(tvOS)
        RectangleCornerRadii(20)
#elseif os(watchOS)
        RectangleCornerRadii(10)
#elseif os(visionOS)
        RectangleCornerRadii(15)
#endif
    }()

    /// Indicates if horizontal corners should switch to support RTL languages.
    public var reversesHorizontalCornersForRTLLanguages: Bool = true

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

    // MARK: Properties - Border
    /// Border width. 
    ///
    /// To hide border, set to `0`.
    public var borderWidth: PointPixelMeasurement = {
#if os(iOS)
        PointPixelMeasurement.points(0)
#elseif os(macOS)
        PointPixelMeasurement.pixels(1)
#elseif os(tvOS)
        PointPixelMeasurement.points(0)
#elseif os(watchOS)
        PointPixelMeasurement.points(0)
#elseif os(visionOS)
        PointPixelMeasurement.points(0)
#endif
    }()

    /// Border color.
    public var borderColor: Color = {
#if os(iOS)
        Color.clear
#elseif os(macOS)
        Color.dynamic(Color(200, 200, 200), Color(100, 100, 100))
#elseif os(tvOS)
        Color.clear
#elseif os(watchOS)
        Color.clear
#elseif os(visionOS)
        Color.clear
#endif
    }()

    // MARK: Properties - Content
    /// Content margins.
    public var contentMargins: EdgeInsets = {
#if os(iOS)
        EdgeInsets(15)
#elseif os(macOS)
        EdgeInsets(7.5)
#elseif os(tvOS)
        EdgeInsets(20)
#elseif os(watchOS)
        EdgeInsets(10)
#elseif os(visionOS)
        EdgeInsets(15)
#endif
    }()

    // MARK: Initializers
    /// Initializes appearance with default values.
    public init() {}
}

@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension VGroupBoxAppearance {
    /// `VGroupBoxAppearance` with `UIColor.systemBackground` to be used on `UIColor.secondarySystemBackground`.
    public static var systemBackgroundColor: Self {
        var appearance: Self = .init()

#if os(iOS)
        appearance.backgroundColor = Color(uiColor: UIColor.systemBackground)
#endif

        return appearance
    }
}
