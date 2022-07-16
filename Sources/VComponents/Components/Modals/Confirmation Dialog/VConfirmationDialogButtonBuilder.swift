//
//  VConfirmationDialogButtonBuilder.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 16.07.22.
//

import Foundation

// MARK: - V Confirmation Dialog Button Convertible
/// Type that allows for conversion to `VConfirmationDialogButton`.
public protocol VConfirmationDialogButtonConvertible {
    /// Converts `VConfirmationDialogButtonConvertible` to `VConfirmationDialogButton` `Array`.
    func toButtons() -> [any VConfirmationDialogButton]
}

extension Array: VConfirmationDialogButtonConvertible where Element == VConfirmationDialogButton {
    public func toButtons() -> [any VConfirmationDialogButton] { self }
}

// MARK: - V Confirmation Dialog Button Builder
/// Custom parameter attribute that constructs views from closures.
@resultBuilder public struct VConfirmationDialogButtonBuilder {
    // MARK: Properties
    public typealias Component = any VConfirmationDialogButtonConvertible
    public typealias Result = [any VConfirmationDialogButton]
    
    // MARK: Build Blocks
    public static func buildBlock() -> Result {
        []
    }
    
    public static func buildBlock(_ components: Component...) -> Result {
        components.flatMap { $0.toButtons() }
    }
    
    public static func buildOptional(_ component: Component?) -> Result {
        component?.toButtons() ?? []
    }
    
    public static func buildEither(first component: Component) -> Result {
        component.toButtons()
    }

    public static func buildEither(second component: Component) -> Result {
        component.toButtons()
    }
    
    public static func buildArray(_ components: [Component]) -> Result {
        components.flatMap { $0.toButtons() }
    }
    
    public static func buildLimitedAvailability(_ component: Component) -> Result {
        component.toButtons()
    }

    public static func buildFinalResult(_ component: Component) -> Result {
        component.toButtons()
    }
}
