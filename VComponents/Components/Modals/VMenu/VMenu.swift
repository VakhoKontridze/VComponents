//
//  VMenu.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/28/21.
//

import SwiftUI

// MARK:- V Menu
/// Modal component that presents menu of actions
///
/// Preset and state can be passed as parameters
///
/// # Usage Example #
///
/// ```
/// VMenu(
///     preset: .secondary(),
///     rows: [
///         .withSystemIcon(action: {}, title: "One", name: "swift"),
///         .withAssetIcon(action: {}, title: "Two", name: "Favorites"),
///         .button(action: {}, title: "Three"),
///         .button(action: {}, title: "Four"),
///         .menu(title: "Five...", rows: [
///             .button(action: {}, title: "One"),
///             .button(action: {}, title: "Two"),
///             .button(action: {}, title: "Three"),
///             .menu(title: "Four...", rows: [
///                 .button(action: {}, title: "One"),
///                 .button(action: {}, title: "Two"),
///             ])
///         ])
///     ],
///     title: "Lorem ipsum"
/// )
/// ```
///
public struct VMenu<Label>: View where Label: View {
    // MARK: Properties
    private let menuType: VMenuType
    private let state: VNavigationLinkState
    private let rows: [VMenuRow]
    private let label: () -> Label
    
    // MARK: Initializers: Preset
    public init(
        preset menuButtonPreset: VMenuButtonPreset,
        state: VNavigationLinkState = .enabled,
        rows: [VMenuRow],
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.menuType = menuButtonPreset.linkType
        self.state = state
        self.rows = rows
        self.label = label
    }
    
    public init(
        preset menuButtonPreset: VMenuButtonPreset,
        state: VNavigationLinkState = .enabled,
        rows: [VMenuRow],
        title: String
    )
        where Label == VText
    {
        self.init(
            preset: menuButtonPreset,
            state: state,
            rows: rows,
            label: { menuButtonPreset.text(from: title, isEnabled: state.isEnabled) }
        )
    }
    
    // MARK: Initializers: Custom
    public init(
        state: VNavigationLinkState = .enabled,
        rows: [VMenuRow],
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.menuType = .custom
        self.state = state
        self.rows = rows
        self.label = label
    }
}

// MARK:- Body
extension VMenu {
    public var body: some View {
        Menu(content: contentView, label: labelView)
            .allowsHitTesting(state.isEnabled)  // Addingthis on label has no effect
    }
    
    private func contentView() -> some View {
        VMenuSubMenu(rows: rows)
    }
    
    // Shared with VNavigationLink
    @ViewBuilder private func labelView() -> some View {
        switch menuType {
        case .primary(let model):
            VPrimaryButton(
                model: model,
                state: state.isEnabled ? .enabled : .disabled,
                action: {},
                content: label
            )
            
        case .secondary(let model):
            VSecondaryButton(
                model: model,
                state: state.isEnabled ? .enabled : .disabled,
                action: {},
                content: label
            )
            
        case .square(let model):
            VSquareButton(
                model: model,
                state: state.isEnabled ? .enabled : .disabled,
                action: {},
                content: label
            )
            
        case .plain(let model):
            VPlainButton(
                model: model,
                state: state.isEnabled ? .enabled : .disabled,
                action: {},
                content: label
            )
            
        case .custom:
            label()
        }
    }
}

// MARK:- Preview
struct VMenu_Previews: PreviewProvider {
    static var previews: some View {
        VMenu(
            preset: .secondary(),
            rows: [
                .withSystemIcon(action: {}, title: "One", name: "swift"),
                .withAssetIcon(action: {}, title: "Two", name: "Favorites"),
                .standard(action: {}, title: "Three"),
                .standard(action: {}, title: "Four"),
                .menu(title: "Five...", rows: [
                    .standard(action: {}, title: "One"),
                    .standard(action: {}, title: "Two"),
                    .standard(action: {}, title: "Three"),
                    .menu(title: "Four...", rows: [
                        .standard(action: {}, title: "One"),
                        .standard(action: {}, title: "Two"),
                    ])
                ])
            ],
            title: "Lorem ipsum"
        )
    }
}
