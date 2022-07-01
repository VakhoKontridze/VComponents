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
/// Unlike native menu, this components doesn't take reverse row order.
///
///     var body: some View {
///         VMenu(
///             rows: [
///                 .titleIcon(action: {}, title: "One", assetIcon: "SomeIcon"),
///                 .titleIcon(action: {}, title: "Two", icon: someIcon),
///                 .titleIcon(action: {}, title: "Three", systemIcon: "swift"),
///                 .title(action: {}, title: "Four"),
///                 .title(action: {}, title: "Five"),
///                 .menu(title: "Five...", rows: [
///                     .title(action: {}, title: "One"),
///                     .title(action: {}, title: "Two"),
///                     .title(action: {}, title: "Three"),
///                     .menu(title: "Four...", rows: [
///                         .title(action: {}, title: "One"),
///                         .title(action: {}, title: "Two")
///                     ])
///                 ])
///             ],
///             label: {
///                 VPlainButton(
///                     action: {},
///                     title: "Lorem Ipsum"
///                 )
///             }
///         )
///     }
///
public struct VMenu<Label>: View where Label: View {
    // MARK: Properties
    @Environment(\.isEnabled) private var isEnabled: Bool
    private var internalState: VMenuInternalState { .init(isEnabled: isEnabled) }
    
    private let rows: [VMenuRow]
    private let label: () -> Label
    
    // MARK: Initializers
    /// Initializes component with rows and label.
    public init(
        rows: [VMenuRow],
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.rows = rows
        self.label = label
    }

    // MARK: Body
    public var body: some View {
        Menu(
            content: { VMenuContentView(rows: rows) },
            label: label
        )
            .disabled(!internalState.isEnabled)
    }
}

// MARK: - Preview
struct VMenu_Previews: PreviewProvider {
    static var previews: some View {
        VMenu(
            rows: [
                .titleIcon(action: {}, title: "One", assetIcon: "XMark", bundle: .module),
                .titleIcon(action: {}, title: "Two", icon: .init(systemName: "swift")),
                .titleIcon(action: {}, title: "Three", systemIcon: "swift"),
                .title(action: {}, title: "Four"),
                .title(action: {}, title: "Five"),
                .menu(title: "Five...", rows: [
                    .title(action: {}, title: "One"),
                    .title(action: {}, title: "Two"),
                    .title(action: {}, title: "Three"),
                    .menu(title: "Four...", rows: [
                        .title(action: {}, title: "One"),
                        .title(action: {}, title: "Two")
                    ])
                ])
            ],
            label: {
                VPlainButton(
                    action: {},
                    title: "Lorem Ipsum"
                )
            }
        )
    }
}
