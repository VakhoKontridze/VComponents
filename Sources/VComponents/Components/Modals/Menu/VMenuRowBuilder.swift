//
//  VMenuRowBuilder.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 01.07.22.
//

import SwiftUI

// MARK: - V Menu Row Convertible
/// Type that allows for conversion to `VMenuRow`.
public protocol VMenuRowConvertible {
    /// Converts `VMenuRowConvertible` to `VMenuRow` `Array`.
    func toRows() -> [any VMenuRow]
}

extension Array: VMenuRowConvertible where Element == VMenuRow {
    public func toRows() -> [any VMenuRow] { self }
}

// MARK: - V Menu Row Builder
/// Custom parameter attribute that constructs views from closures.
@resultBuilder public struct VMenuRowBuilder {
    // MARK: Properties
    public typealias Component = any VMenuRowConvertible
    public typealias Result = [any VMenuRow]
    
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
