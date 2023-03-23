//
//  VConfirmationDialogButtonBuilder.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 16.07.22.
//

import Foundation

// MARK: - V Confirmation Dialog Button Convertible
/// Type that allows for conversion to `VConfirmationDialogButtonProtocol`.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public protocol VConfirmationDialogButtonConvertible {
    /// Converts `VConfirmationDialogButtonConvertible` to `VConfirmationDialogButton` `Array`.
    func toButtons() -> [any VConfirmationDialogButtonProtocol]
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension Array: VConfirmationDialogButtonConvertible where Element == VConfirmationDialogButtonProtocol {
    public func toButtons() -> [any VConfirmationDialogButtonProtocol] { self }
}

// MARK: - V Confirmation Dialog Button Builder
/// Custom parameter attribute that constructs views from closures.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
@resultBuilder public struct VConfirmationDialogButtonBuilder {
    // MARK: Properties
    public typealias Component = any VConfirmationDialogButtonConvertible
    public typealias Result = [any VConfirmationDialogButtonProtocol]
    
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
    // If there are multiple `VConfirmationDialogCancelButton`s, only the last one will be kept.
    // `VConfirmationDialogCancelButton` will be moved to the end of the stack.
    // If there are no buttons, custom `VConfirmationDialogOKButton` will be added.
    static func process(_ buttons: [any VConfirmationDialogButtonProtocol]) -> [any VConfirmationDialogButtonProtocol] {
        var result: [any VConfirmationDialogButtonProtocol] = []

        for button in buttons {
            if button is VConfirmationDialogCancelButton { result.removeAll(where: { $0 is VConfirmationDialogCancelButton }) }
            result.append(button)
        }
        if let cancelButtonIndex: Int = result.firstIndex(where: { $0 is VConfirmationDialogCancelButton }) {
            result.append(result.remove(at: cancelButtonIndex))
        }

        if result.isEmpty {
            result.append(VConfirmationDialogCancelButton(
                action: nil,
                title: VComponentsLocalizationManager.shared.localizationProvider.vConfirmationDialogOKButtonTitle
            ))
        }

        return result
    }
}
