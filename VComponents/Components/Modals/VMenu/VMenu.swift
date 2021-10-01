//
//  VMenu.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/28/21.
//

import SwiftUI

// MARK: - V Menu
/// Modal component that presents menu of actions.
///
/// Preset and state can be passed as parameters.
///
/// # Usage Example #
///
/// ```
/// VMenu(
///     preset: .secondary(),
///     rows: [
///         .titledSystemIcon(action: {}, title: "One", name: "swift"),
///         .titledAssetIcon(action: {}, title: "Two", name: "Favorites"),
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
    private let menuButtonType: VMenuButtonType
    private let state: VMenuState
    private let rows: [VMenuRow]
    private let label: () -> Label
    
    // MARK: Initializers - Preset
    /// Initializes component with preset, rows, and label.
    public init(
        preset menuButtonPreset: VMenuButtonPreset,
        state: VMenuState = .enabled,
        rows: [VMenuRow],
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.menuButtonType = menuButtonPreset.buttonType
        self.state = state
        self.rows = rows
        self.label = label
    }
    
    /// Initializes component with preset, rows, and title.
    public init(
        preset menuButtonPreset: VMenuButtonPreset,
        state: VMenuState = .enabled,
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
    
    // MARK: Initializers - Custom
    /// Initializes component with rows and label.
    public init(
        state: VMenuState = .enabled,
        rows: [VMenuRow],
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.menuButtonType = .custom
        self.state = state
        self.rows = rows
        self.label = label
    }

    // MARK: Body
    public var body: some View {
        Menu(content: contentView, label: labelView)
            .allowsHitTesting(state.isEnabled)  // Adding this on label has no effect
    }
    
    private func contentView() -> some View {
        VMenuSubMenu(rows: rows)
    }
    
    @ViewBuilder private func labelView() -> some View {
        VMenuButtonType.menuButton(
            buttonType: menuButtonType,
            isEnabled: state.isEnabled,
            label: label
        )
    }
}

// MARK: - Preview
struct VMenu_Previews: PreviewProvider {
    static var previews: some View {
        VMenu(
            preset: .secondary(),
            rows: [
                .titledSystemIcon(action: {}, title: "One", name: "swift"),
                .titledAssetIcon(action: {}, title: "Two", name: "Favorites"),
                .titled(action: {}, title: "Three"),
                .titled(action: {}, title: "Four"),
                .menu(title: "Five...", rows: [
                    .titled(action: {}, title: "One"),
                    .titled(action: {}, title: "Two"),
                    .titled(action: {}, title: "Three"),
                    .menu(title: "Four...", rows: [
                        .titled(action: {}, title: "One"),
                        .titled(action: {}, title: "Two"),
                    ])
                ])
            ],
            title: "Lorem ipsum"
        )
    }
}
