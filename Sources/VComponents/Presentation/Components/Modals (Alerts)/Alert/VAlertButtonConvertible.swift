//
//  VAlertButtonConvertible.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 01.05.23.
//

public import SwiftUI

/// Type that allows for conversion to `VAlertButtonProtocol`.
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public protocol VAlertButtonConvertible {
    /// Converts self to `VAlertButtonProtocol` `Array`.
    func toButtons() -> [any VAlertButtonProtocol]
}

@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension [any VAlertButtonProtocol]: VAlertButtonConvertible {
    public func toButtons() -> [any VAlertButtonProtocol] {
        self
    }
}

@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension Never: VAlertButtonConvertible {
    public func toButtons() -> [any VAlertButtonProtocol] {
        fatalError()
    }
}

@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension EmptyView: VAlertButtonConvertible {
    public func toButtons() -> [any VAlertButtonProtocol] {
        []
    }
}
