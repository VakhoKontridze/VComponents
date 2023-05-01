//
//  VAlertButtonConvertible.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 01.05.23.
//

import SwiftUI

// MARK: - V Alert Button Convertible
/// Type that allows for conversion to `VAlertButtonProtocol`.
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public protocol VAlertButtonConvertible {
    /// Converts self to `VAlertButtonProtocol` `Array`.
    func toButtons() -> [any VAlertButtonProtocol]
}

@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension Array: VAlertButtonConvertible where Element == any VAlertButtonProtocol {
    public func toButtons() -> [any VAlertButtonProtocol] { self }
}

@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension EmptyView: VAlertButtonConvertible {
    public func toButtons() -> [any VAlertButtonProtocol] { [] }
}
