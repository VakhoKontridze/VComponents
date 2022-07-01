//
//  VMenuSectionBuilder.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 01.07.22.
//

import SwiftUI

// MARK: - V Menu Section Convertible
/// Type that allows for conversion to `VMenuSection`.
public protocol VMenuSectionConvertible {
    /// Converts `VMenuSectionConvertible` to `VMenuSection` `Array`.
    func toSections() -> [any VMenuSection]
}

extension Array: VMenuSectionConvertible where Element == VMenuSection {
    public func toSections() -> [any VMenuSection] { self }
}

// MARK: - V Menu Section Builder
/// A custom parameter attribute that constructs views from closures.
@resultBuilder public struct VMenuSectionBuilder {
    // MARK: Properties
    public typealias Component = any VMenuSectionConvertible
    public typealias Return = [any VMenuSection]
    
    // MARK: Build Blocks
    public static func buildBlock() -> Return {
        []
    }
    
    public static func buildBlock(_ components: Component...) -> Return {
        components.flatMap { $0.toSections() }
    }
    
    public static func buildOptional(_ component: Component?) -> Return {
        component?.toSections() ?? []
    }
    
    public static func buldIf(_ component: Component?) -> Return {
        component?.toSections() ?? []
    }

    public static func buildEither(first component: Component) -> Return {
        component.toSections()
    }

    public static func buildEither(second component: Component) -> Return {
        component.toSections()
    }
    
    public static func buildArray(_ components: [Component]) -> Return {
        components.flatMap { $0.toSections() }
    }
    
    public static func buildLimitedAvailability(_ component: Component) -> Return {
        component.toSections()
    }

    public static func buildFinalResult(_ component: Component) -> Return {
        component.toSections()
    }

    //public static func buildExpression(_ expression: Expression) -> Return {}
}
