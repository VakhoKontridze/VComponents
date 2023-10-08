//
//  VMenuSectionConvertible.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 01.05.23.
//

import SwiftUI

// MARK: - V Menu Section Convertible
/// Type that allows for conversion to `VMenuSectionProtocol`.
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public protocol VMenuSectionConvertible {
    /// Converts self to `VMenuSectionProtocol` `Array`.
    func toSections() -> [any VMenuSectionProtocol]
}

@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension Array: VMenuSectionConvertible where Element == any VMenuSectionProtocol {
    public func toSections() -> [any VMenuSectionProtocol] { self }
}

@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension EmptyView: VMenuSectionConvertible {
    public func toSections() -> [any VMenuSectionProtocol] { [] }
}
