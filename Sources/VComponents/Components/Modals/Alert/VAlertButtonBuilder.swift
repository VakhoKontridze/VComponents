//
//  VAlertButtonBuilder.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 16.07.22.
//

import Foundation
import VCore

// MARK: - V Alert Button Builder
/// Custom parameter attribute that constructs views from closures.
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
@resultBuilder 
public struct VAlertButtonBuilder {
    // MARK: Properties
    public typealias Component = any VAlertButtonConvertible
    public typealias Result = [any VAlertButtonProtocol]
    
    // MARK: Build Blocks
    @MainActor
    public static func buildBlock() -> Result {
        []
    }
    
    @MainActor
    public static func buildBlock(_ components: Component...) -> Result {
        components.flatMap { $0.toButtons() }
    }
    
    @MainActor
    public static func buildOptional(_ component: Component?) -> Result {
        component?.toButtons() ?? []
    }
    
    @MainActor
    public static func buildEither(first component: Component) -> Result {
        component.toButtons()
    }
    
    @MainActor
    public static func buildEither(second component: Component) -> Result {
        component.toButtons()
    }
    
    @MainActor
    public static func buildArray(_ components: [Component]) -> Result {
        components.flatMap { $0.toButtons() }
    }
    
    @MainActor
    public static func buildLimitedAvailability(_ component: Component) -> Result {
        component.toButtons()
    }
    
    @MainActor
    public static func buildFinalResult(_ component: Component) -> Result {
        component.toButtons()
    }
    
    // MARK: Processing
    // If there are multiple `cancel` `VAlertButton`s, only the last one will be kept.
    // `cancel` `VAlertButton` will be moved to the end of the stack.
    // If there are no buttons, `VAlertOKButton` will be added.
    @MainActor
    static func process(_ buttons: [any VAlertButtonProtocol]) -> [any VAlertButtonProtocol] {
        var result: [any VAlertButtonProtocol] = []

        for button in buttons {
            if (button as? VAlertButton)?.role == .cancel {
                result.removeAll(where: { ($0 as? VAlertButton)?.role == .cancel })
            }
            result.append(button)
        }
        if let cancelButtonIndex: Int = result.firstIndex(where: { ($0 as? VAlertButton)?.role == .cancel }) {
            result.append(result.remove(at: cancelButtonIndex))
        }

        if result.isEmpty {
            result.append(
                VAlertButton(
                    role: .secondary,
                    action: nil,
                    title: VComponentsLocalizationManager.shared.localizationProvider.vAlertOKButtonTitle
                )
            )
        }

        return result
    }
}
