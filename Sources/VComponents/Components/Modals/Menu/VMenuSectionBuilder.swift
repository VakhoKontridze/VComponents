//
//  VMenuSectionBuilder.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 01.07.22.
//

import Foundation

// MARK: - V Menu Section Builder
/// Custom parameter attribute that constructs views from closures.
@available(iOS 15.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@resultBuilder public struct VMenuSectionBuilder {
    // MARK: Properties
    public typealias Component = any VMenuSectionConvertible
    public typealias Result = [any VMenuSectionProtocol]
    
    // MARK: Build Blocks
    public static func buildBlock() -> Result {
        []
    }
    
    public static func buildBlock(_ components: Component...) -> Result {
        components.flatMap { $0.toSections() }
    }
    
    public static func buildOptional(_ component: Component?) -> Result {
        component?.toSections() ?? []
    }
    
    public static func buildEither(first component: Component) -> Result {
        component.toSections()
    }
    
    public static func buildEither(second component: Component) -> Result {
        component.toSections()
    }
    
    public static func buildArray(_ components: [Component]) -> Result {
        components.flatMap { $0.toSections() }
    }
    
    public static func buildLimitedAvailability(_ component: Component) -> Result {
        component.toSections()
    }
    
    public static func buildFinalResult(_ component: Component) -> Result {
        component.toSections()
    }
}
