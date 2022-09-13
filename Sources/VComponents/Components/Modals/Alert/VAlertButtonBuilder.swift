//
//  VAlertButtonBuilder.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 16.07.22.
//

import Foundation

// MARK: - V Alert Button Convertible
/// Type that allows for conversion to `VAlertButtonProtocol`.
public protocol VAlertButtonConvertible {
    /// Converts `VAlertButtonConvertible` to `VAlertButtonProtocol` `Array`.
    func toButtons() -> [any VAlertButtonProtocol]
}

extension Array: VAlertButtonConvertible where Element == VAlertButtonProtocol {
    public func toButtons() -> [any VAlertButtonProtocol] { self }
}

// MARK: - V Alert Button Builder
/// Custom parameter attribute that constructs views from closures.
@resultBuilder public struct VAlertButtonBuilder {
    // MARK: Properties
    public typealias Component = any VAlertButtonConvertible
    public typealias Result = [any VAlertButtonProtocol]
    
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
    
    // MARK: Processing
    // If there are multiple `VAlertCancelButton`s, only the last one will be kept.
    // `VAlertCancelButton` will be moved to the end of the stack.
    // If there are no buttons, `VAlertOKButton` will be added.
    static func process(_ buttons: [any VAlertButtonProtocol]) -> [any VAlertButtonProtocol] {
        var result: [any VAlertButtonProtocol] = []

        for button in buttons {
            if button is VAlertCancelButton { result.removeAll(where: { $0 is VAlertCancelButton }) }
            result.append(button)
        }
        if let cancelButtonIndex: Int = result.firstIndex(where: { $0 is VAlertCancelButton }) {
            result.append(result.remove(at: cancelButtonIndex))
        }

        if result.isEmpty {
            result.append(VAlertOKButton(action: nil))
        }

        return result
    }
}
