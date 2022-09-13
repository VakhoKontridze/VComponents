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
///     enum PickerRow: Int, StringRepresentableHashableEnumeration {
///         case red, green, blue
///
///         var stringRepresentation: String {
///             switch self {
///             case .red: return "Red"
///             case .green: return "Green"
///             case .blue: return "Blue"
///             }
///         }
///     }
///
///     @State var selection: PickerRow = .red
///
///     var body: some View {
///         VMenu(title: "Lorem Ipsum", sections: {
///             VMenuGroupSection(title: "Section 1", rows: {
///                 VMenuTitleRow(action: { print("1.1") }, title: "One")
///                 VMenuTitleIconRow(action: { print("1.2") }, title: "Two", systemIcon: "swift")
///             })
///
///             VMenuGroupSection(title: "Section 2", rows: {
///                 VMenuTitleRow(action: { print("2.1") }, title: "One")
///
///                 VMenuTitleIconRow(action: { print("2.2") }, title: "Two", systemIcon: "swift")
///
///                 VMenuSubMenuRow(title: "Three...", sections: {
///                     VMenuGroupSection(rows: {
///                         VMenuTitleRow(action: { print("2.3.1") }, title: "One")
///                         VMenuTitleIconRow(action: { print("2.3.2") }, title: "Two", systemIcon: "swift")
///                     })
///                 })
///             })
///
///             VMenuPickerSection(selection: $selection)
///         })
///     }
///
public struct VMenu<Label>: View where Label: View {
    // MARK: Properties
    @Environment(\.isEnabled) private var isEnabled: Bool
    private var internalState: VMenuInternalState { .init(isEnabled: isEnabled) }
    
    private let sections: () -> [any VMenuSectionProtocol]
    private let primaryAction: (() -> Void)?
    private let label: VMenuLabel<Label>
    
    // MARK: Initializers - Sections
    /// Initializes component with label and sections.
    public init(
        primaryAction: (() -> Void)? = nil,
        @ViewBuilder label: @escaping () -> Label,
        @VMenuSectionBuilder sections: @escaping () -> [any VMenuSectionProtocol]
    ) {
        self.sections = sections
        self.primaryAction = primaryAction
        self.label = .custom(label: label)
    }
    
    /// Initializes component with title and sections.
    public init(
        primaryAction: (() -> Void)? = nil,
        title: String,
        @VMenuSectionBuilder sections: @escaping () -> [any VMenuSectionProtocol]
    )
        where Label == Never
    {
        self.sections = sections
        self.primaryAction = primaryAction
        self.label = .title(title: title)
    }
    
    // MARK: Initializers - Rows
    /// Initializes component with label and rows.
    public init(
        primaryAction: (() -> Void)? = nil,
        @ViewBuilder label: @escaping () -> Label,
        @VMenuRowBuilder rows: @escaping () -> [any VMenuRowProtocol]
    ) {
        self.sections = { [VMenuGroupSection(rows: rows)] }
        self.primaryAction = primaryAction
        self.label = .custom(label: label)
    }
    
    /// Initializes component with title and rows.
    public init(
        primaryAction: (() -> Void)? = nil,
        title: String,
        @VMenuRowBuilder rows: @escaping () -> [any VMenuRowProtocol]
    )
        where Label == Never
    {
        self.sections = { [VMenuGroupSection(rows: rows)] }
        self.primaryAction = primaryAction
        self.label = .title(title: title)
    }

    // MARK: Body
    public var body: some View {
        if #available(iOS 16.0, *) { // FIXME: Remove availability check
            Group(content: {
                if let primaryAction {
                    Menu(
                        content: contentView,
                        label: menuLabel,
                        primaryAction: primaryAction
                    )
                } else {
                    Menu(
                        content: contentView,
                        label: menuLabel
                    )
                }
            })
                .disabled(!internalState.isEnabled)
                .menuOrder(.fixed)
        }
    }
    
    private func contentView() -> some View {
        ForEach(
            sections().enumeratedArray(),
            id: \.offset,
            content: { (_, section) in
                TitledSection(
                    title: section.title,
                    content: { section.body }
                )
            }
        )
    }
    
    @ViewBuilder private func menuLabel() -> some View {
        switch label {
        case .title(let title):
            VPlainButton(action: {}, title: title)
            
        case .custom(let label):
            label()
        }
    }
}

// MARK: - Preview
import VCore

struct VMenu_Previews: PreviewProvider {
    private enum PickerRow: Int, StringRepresentableHashableEnumeration {
        case red, green, blue

        var stringRepresentation: String {
            switch self {
            case .red: return "Red"
            case .green: return "Green"
            case .blue: return "Blue"
            }
        }
    }

    @State private static var selection: PickerRow = .red
    
    static var previews: some View {
        VMenu(title: "Lorem Ipsum", sections: {
            VMenuGroupSection(title: "Section 1", rows: {
                VMenuTitleRow(action: { print("1.1") }, title: "One")
                VMenuTitleIconRow(action: { print("1.2") }, title: "Two", systemIcon: "swift")
            })
            
            VMenuGroupSection(title: "Section 2", rows: {
                VMenuTitleRow(action: { print("2.1") }, title: "One")
                
                VMenuTitleIconRow(action: { print("2.2") }, title: "Two", systemIcon: "swift")
                
                VMenuSubMenuRow(title: "Three...", sections: {
                    VMenuGroupSection(rows: {
                        VMenuTitleRow(action: { print("2.3.1") }, title: "One")
                        VMenuTitleIconRow(action: { print("2.3.2") }, title: "Two", systemIcon: "swift")
                    })
                })
            })
            
            VMenuPickerSection(selection: $selection)
        })
    }
}
