//
//  VMenuRowBuilder.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 01.07.22.
//

import SwiftUI

// MARK: - V Menu Row Convertible
/// Type that allows for conversion to `VMenuRowProtocol`.
@available(iOS 15.0, *)
@available(macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public protocol VMenuRowConvertible {
    /// Converts `VMenuRowConvertible` to `VMenuRowProtocol` `Array`.
    func toRows() -> [any VMenuRowProtocol]
}

@available(iOS 15.0, *)
@available(macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension Array: VMenuRowConvertible where Element == VMenuRowProtocol {
    public func toRows() -> [any VMenuRowProtocol] { self }
}

// MARK: - V Menu Row Builder
/// Custom parameter attribute that constructs views from closures.
@available(iOS 15.0, *)
@available(macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@resultBuilder public struct VMenuRowBuilder {
    // MARK: Properties
    public typealias Component = any VMenuRowConvertible
    public typealias Result = [any VMenuRowProtocol]
    
    // MARK: Build Blocks
    public static func buildBlock() -> Result {
        []
    }
    
    public static func buildBlock(_ components: Component...) -> Result {
        components.flatMap { $0.toRows() }
    }
    
    public static func buildOptional(_ component: Component?) -> Result {
        component?.toRows() ?? []
    }
    
    public static func buildEither(first component: Component) -> Result {
        component.toRows()
    }

    public static func buildEither(second component: Component) -> Result {
        component.toRows()
    }
    
    public static func buildArray(_ components: [Component]) -> Result {
        components.flatMap { $0.toRows() }
    }
    
    public static func buildLimitedAvailability(_ component: Component) -> Result {
        component.toRows()
    }

    public static func buildFinalResult(_ component: Component) -> Result {
        component.toRows()
    }
}
