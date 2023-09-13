//
//  VMenuRowBuilder.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 01.07.22.
//

import Foundation

// MARK: - V Menu Group Row Builder
/// Custom parameter attribute that constructs views from closures.
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@resultBuilder public struct VMenuGroupRowBuilder {
    // MARK: Properties
    public typealias Component = any VMenuGroupRowConvertible
    public typealias Result = [any VMenuGroupRowProtocol]
    
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

// MARK: - V Menu Picker Row Builder
// NOTE: No need for this builder
