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
///     private enum RGBColor: Int, Hashable, Identifiable, CaseIterable, StringRepresentable {
///         case red, green, blue
///
///         var id: Int { rawValue }
///         var stringRepresentation: String { .init(describing: self).capitalized }
///     }
///
///     @State private var selection: RGBColor = .red
///
///     var body: some View {
///         VMenu(title: "Lorem Ipsum", sections: {
///             VMenuGroupSection(title: "Section 1", rows: {
///                 VMenuRow(action: { print("1") }, title: "One")
///                 VMenuRow(action: { print("2") }, title: "Two", icon: Image(systemName: "swift"))
///                 VMenuExpandingRow(title: "Three...", sections: {
///                     VMenuGroupSection(rows: {
///                         VMenuRow(action: { print("3.1") }, title: "One")
///                         VMenuRow(action: { print("3.2") }, title: "Two", icon: Image(systemName: "swift"))
///                     })
///                 })
///             })
///
///             VMenuPickerSection(selection: $selection)
///         })
///     }
///
@available(iOS 15.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct VMenu<Label>: View where Label: View {
    // MARK: Properties
    private let uiModel: VMenuUIModel
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    private var internalState: VMenuInternalState { .init(isEnabled: isEnabled) }
    
    private let primaryAction: (() -> Void)?
    
    private let label: VMenuLabel<Label>
    private let sections: () -> [any VMenuSectionProtocol]
    
    // MARK: Initializers - Sections
    /// Initializes `VMenu` with title and sections.
    public init(
        uiModel: VMenuUIModel = .init(),
        primaryAction: (() -> Void)? = nil,
        title: String,
        @VMenuSectionBuilder sections: @escaping () -> [any VMenuSectionProtocol]
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self.primaryAction = primaryAction
        self.label = .title(title: title)
        self.sections = sections
    }
    
    /// Initializes `VMenu` with label and sections.
    public init(
        uiModel: VMenuUIModel = .init(),
        primaryAction: (() -> Void)? = nil,
        @ViewBuilder label: @escaping (VMenuInternalState) -> Label,
        @VMenuSectionBuilder sections: @escaping () -> [any VMenuSectionProtocol]
    ) {
        self.uiModel = uiModel
        self.primaryAction = primaryAction
        self.label = .content(content: label)
        self.sections = sections
    }
    
    // MARK: Initializers - Rows
    /// Initializes `VMenu` with title and rows.
    public init(
        uiModel: VMenuUIModel = .init(),
        primaryAction: (() -> Void)? = nil,
        title: String,
        @VMenuGroupRowBuilder rows: @escaping () -> [any VMenuGroupRowProtocol]
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self.primaryAction = primaryAction
        self.label = .title(title: title)
        self.sections = { [VMenuGroupSection(rows: rows)] }
    }
    
    /// Initializes `VMenu` with label and rows.
    public init(
        uiModel: VMenuUIModel = .init(),
        primaryAction: (() -> Void)? = nil,
        @ViewBuilder label: @escaping (VMenuInternalState) -> Label,
        @VMenuGroupRowBuilder rows: @escaping () -> [any VMenuGroupRowProtocol]
    ) {
        self.uiModel = uiModel
        self.primaryAction = primaryAction
        self.label = .content(content: label)
        self.sections = { [VMenuGroupSection(rows: rows)] }
    }
    
    // MARK: Body
    public var body: some View {
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
        .applyModifier({
            if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
                $0.menuOrder(.fixed)
            } else {
                $0
            }
        })
    }
    
    private func contentView() -> some View {
        ForEach(
            sections().enumeratedArray(),
            id: \.offset,
            content: { (_, section) in
                TitledSection(
                    title: section.title,
                    content: { section.makeBody() }
                )
            }
        )
    }
    
    @ViewBuilder private func menuLabel() -> some View {
        switch label {
        case .title(let title):
            Text(title)
                .foregroundColor(uiModel.colors.label.value(for: internalState))
            
        case .content(let label):
            label(internalState)
        }
    }
}

// MARK: - Preview
import VCore

// Developmental only
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct VMenu_Previews: PreviewProvider {
    // Configuration
    private static var interfaceOrientation: InterfaceOrientation { .portrait }
    private static var languageDirection: LayoutDirection { .leftToRight }
    private static var dynamicTypeSize: DynamicTypeSize? { nil }
    private static var colorScheme: ColorScheme { .light }
    
    // Previews
    static var previews: some View {
        Group(content: {
            Preview().previewDisplayName("*")
        })
        .previewInterfaceOrientation(interfaceOrientation)
        .environment(\.layoutDirection, languageDirection)
        .applyIfLet(dynamicTypeSize, transform: { $0.dynamicTypeSize($1) })
        .colorScheme(colorScheme)
    }
    
    // Data
    private enum RGBColor: Int, Hashable, Identifiable, CaseIterable, StringRepresentable {
        case red, green, blue

        var id: Int { rawValue }

        var stringRepresentation: String { _stringRepresentation.pseudoRTL(languageDirection) }
        private var _stringRepresentation: String { .init(describing: self).capitalized }
    }
    
    // Previews (Scenes)
    private struct Preview: View { // Didn't bother with pseudoRTL
        @State private var selection: RGBColor = .red
        
        var body: some View {
            PreviewContainer(content: {
                VMenu(title: "Lorem Ipsum", sections: {
                    VMenuGroupSection(title: "Section 1", rows: {
                        VMenuRow(action: { print("1") }, title: "One")
                        VMenuRow(action: { print("2") }, title: "Two", icon: Image(systemName: "swift"))
                        VMenuExpandingRow(title: "Three...", sections: {
                            VMenuGroupSection(rows: {
                                VMenuRow(action: { print("3.1") }, title: "One")
                                VMenuRow(action: { print("3.2") }, title: "Two", icon: Image(systemName: "swift"))
                            })
                        })
                    })
                    
                    VMenuPickerSection(selection: $selection)
                })
            })
        }
    }
}
