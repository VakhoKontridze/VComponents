//
//  VAlertButtonBuilder.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 16.07.22.
//

import Foundation

// MARK: - V Alert Button Builder
/// Custom parameter attribute that constructs views from closures.
///
///     @State private var isPresented: Bool = false
///
///     var body: some View {
///         VPlainButton(
///             action: { isPresented = true },
///             title: "Present"
///         )
///         .vAlert(
///             id: "some_alert",
///             isPresented: $isPresented,
///             title: "Lorem Ipsum",
///             message: "Lorem ipsum dolor sit amet",
///             actions: {
///                 VAlertButton(role: .primary, action: { print("Confirmed") }, title: "Confirm")
///                 VAlertButton(role: .cancel, action: { print("Cancelled") }, title: "Cancel")
///             }
///         )
///     }
///
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
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
            if (button as? VAlertButton)?.role == .cancel {
                result.removeAll(where: { ($0 as? VAlertButton)?.role == .cancel })
            }
            result.append(button)
        }
        if let cancelButtonIndex: Int = result.firstIndex(where: { ($0 as? VAlertButton)?.role == .cancel }) {
            result.append(result.remove(at: cancelButtonIndex))
        }

        if result.isEmpty {
            result.append(VAlertButton(
                role: .secondary,
                action: nil,
                title: VComponentsLocalizationManager.shared.localizationProvider.vAlertOKButtonTitle
            ))
        }

        return result
    }
}
