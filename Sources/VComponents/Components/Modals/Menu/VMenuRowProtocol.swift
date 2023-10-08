//
//  VMenuRowProtocol.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 01.05.23.
//

import SwiftUI

// MARK: - V Menu Group Row Protocol
/// `VMenu` group row protocol.
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public protocol VMenuGroupRowProtocol: VMenuGroupRowConvertible {
    /// Body type.
    typealias Body = AnyView

    /// Creates a `View` that represents the body of a row.
    func makeBody() -> Body
}

@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VMenuGroupRowProtocol {
    public func toRows() -> [any VMenuGroupRowProtocol] { [self] }
}

// MARK: - V Menu Picker Row Protocol
/// `VMenu` picker row protocol.
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public protocol VMenuPickerRowProtocol: VMenuPickerRowConvertible {
    /// Body type.
    typealias Body = AnyView

    /// Creates a `View` that represents the body of a row.
    func makeBody() -> Body
}

@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VMenuPickerRowProtocol {
    public func toRows() -> [any VMenuPickerRowProtocol] { [self] }
}
