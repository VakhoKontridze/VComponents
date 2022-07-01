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
/// A custom parameter attribute that constructs views from closures.
@resultBuilder public struct VMenuRowBuilder {
    // MARK: Properties
    public typealias Component = any VMenuRowConvertible
    public typealias Return = [any VMenuRow]
    
    // MARK: Blocks
    public static func buildBlock() -> Return {
        []
    }
    
    public static func buildBlock(_ components: Component...) -> Return {
        components.flatMap { $0.toRows() }
    }
    
    public static func buildOptional(_ component: Component?) -> Return {
        component?.toRows() ?? []
    }
    
    public static func buldIf(_ component: Component?) -> Return {
        component?.toRows() ?? []
    }

    public static func buildEither(first component: Component) -> Return {
        component.toRows()
    }

    public static func buildEither(second component: Component) -> Return {
        component.toRows()
    }
    
    public static func buildArray(_ components: [Component]) -> Return {
        components.flatMap { $0.toRows() }
    }
    
    public static func buildLimitedAvailability(_ component: Component) -> Return {
        component.toRows()
    }

    public static func buildFinalResult(_ component: Component) -> Return {
        component.toRows()
    }

    //public static func buildExpression(_ expression: Expression) -> Return {}
}
