//
//  VAlertButtonConvertible.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 01.05.23.
//

import SwiftUI

// MARK: - V Alert Button Convertible
/// Type that allows for conversion to `VAlertButton`.
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public protocol VAlertButtonConvertible {
    /// Converts self to `VAlertButton` `Array`.
    func toButtons() -> [VAlertButton]
}

@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VAlertButton: VAlertButtonConvertible {
    public func toButtons() -> [VAlertButton] { [self] }
}

@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension Array: VAlertButtonConvertible where Element == VAlertButton {
    public func toButtons() -> [VAlertButton] { self }
}

@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension EmptyView: VAlertButtonConvertible {
    public func toButtons() -> [VAlertButton] { [] }
}
