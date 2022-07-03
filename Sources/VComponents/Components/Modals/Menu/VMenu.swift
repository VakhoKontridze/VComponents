//
//  VMenu.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/28/21.
//

import SwiftUI
import VCore

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
///                 VMenuTitleRow(action: {}, title: "One")
///                 VMenuTitleIconRow(action: {}, title: "Two", systemIcon: "swift")
///             })
///
///             VMenuGroupSection(title: "Section 2", rows: {
///                 VMenuTitleRow(action: {}, title: "One")
///
///                 VMenuTitleIconRow(action: {}, title: "Two", systemIcon: "swift")
///
///                 VMenuSubMenuRow(title: "Three...", sections: {
///                     VMenuGroupSection(rows: {
///                         VMenuTitleRow(action: {}, title: "One")
///                         VMenuTitleIconRow(action: {}, title: "Two", systemIcon: "swift")
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
    
    private let sections: () -> [any VMenuSection]
    private let primaryAction: (() -> Void)?
    private let label: VMenuLabel<Label>
    
    // MARK: Initializers - Sections
    /// Initializes component with label and sections.
    public init(
        primaryAction: (() -> Void)? = nil,
        @ViewBuilder label: @escaping () -> Label,
        @VMenuSectionBuilder sections: @escaping () -> [any VMenuSection]
    ) {
        self.sections = sections
        self.primaryAction = primaryAction
        self.label = .custom(label: label)
    }
    
    /// Initializes component with title and sections.
    public init(
        primaryAction: (() -> Void)? = nil,
        title: String,
        @VMenuSectionBuilder sections: @escaping () -> [any VMenuSection]
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
        @VMenuRowBuilder rows: @escaping () -> [any VMenuRow]
    ) {
        self.sections = { [VMenuGroupSection(rows: rows)] }
        self.primaryAction = primaryAction
        self.label = .custom(label: label)
    }
    
    /// Initializes component with title and rows.
    public init(
        primaryAction: (() -> Void)? = nil,
        title: String,
        @VMenuRowBuilder rows: @escaping () -> [any VMenuRow]
    )
        where Label == Never
    {
        self.sections = { [VMenuGroupSection(rows: rows)] }
        self.primaryAction = primaryAction
        self.label = .title(title: title)
    }

    // MARK: Body
    public var body: some View {
        Menu(
            content: contentView,
            label: menuLabel,
            primaryAction: { primaryAction?() }
        )
            .disabled(!internalState.isEnabled)
    }
    
    private func contentView() -> some View {
        ForEach(
            sections().enumeratedArray().reversed(),
            id: \.offset,
            content: { (_, section) in
                if let title: String = section.title {
                    Section(title, content: { section.body })
                } else {
                    Section(content: { section.body })
                }
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
                VMenuTitleRow(action: {}, title: "One")
                VMenuTitleIconRow(action: {}, title: "Two", systemIcon: "swift")
            })
            
            VMenuGroupSection(title: "Section 2", rows: {
                VMenuTitleRow(action: {}, title: "One")
                
                VMenuTitleIconRow(action: {}, title: "Two", systemIcon: "swift")
                
                VMenuSubMenuRow(title: "Three...", sections: {
                    VMenuGroupSection(rows: {
                        VMenuTitleRow(action: {}, title: "One")
                        VMenuTitleIconRow(action: {}, title: "Two", systemIcon: "swift")
                    })
                })
            })
            
            VMenuPickerSection(selection: $selection)
        })
    }
}
