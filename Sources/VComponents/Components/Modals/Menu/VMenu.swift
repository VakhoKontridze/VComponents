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
///             VMenuGroupSection(headerTitle: "Section 1", rows: {
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
/// Unlike native menu, menu doesn't reverse actions.
@available(iOS 15.0, macOS 12.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct VMenu<Label>: View where Label: View {
    // MARK: Properties - UI Model
    private let uiModel: VMenuUIModel

    // MARK: Properties - State
    @Environment(\.isEnabled) private var isEnabled: Bool
    private var internalState: VMenuInternalState {
        .init(isEnabled: isEnabled)
    }

    // MARK: Properties - Action
    private let primaryAction: (() -> Void)?

    // MARK: Properties - Label
    private let label: VMenuLabel<Label>

    // MARK: Properties - Sections
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

    /// Initializes `VMenu` with icon and sections.
    public init(
        uiModel: VMenuUIModel = .init(),
        primaryAction: (() -> Void)? = nil,
        icon: Image,
        @VMenuSectionBuilder sections: @escaping () -> [any VMenuSectionProtocol]
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self.primaryAction = primaryAction
        self.label = .icon(icon: icon)
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

    /// Initializes `VMenu` with icon and rows.
    public init(
        uiModel: VMenuUIModel = .init(),
        primaryAction: (() -> Void)? = nil,
        icon: Image,
        @VMenuGroupRowBuilder rows: @escaping () -> [any VMenuGroupRowProtocol]
    )
        where Label == Never
    {
        self.uiModel = uiModel
        self.primaryAction = primaryAction
        self.label = .icon(icon: icon)
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
                    headerTitle: section.headerTitle,
                    content: { section.makeBody() }
                )
            }
        )
    }
    
    private func menuLabel() -> some View {
        Group(content: {
            switch label {
            case .title(let title):
                titleLabelComponent(title: title)

            case .icon(let icon):
                iconLabelComponent(icon: icon)

            case .content(let label):
                label(internalState)
            }
        })
        .padding(uiModel.hitBox)
    }

    private func titleLabelComponent(
        title: String
    ) -> some View {
        Text(title)
            .lineLimit(1)
            .minimumScaleFactor(uiModel.titleTextMinimumScaleFactor)
            .foregroundColor(uiModel.titleTextColors.value(for: internalState))
            .font(uiModel.titleTextFont)
    }

    private func iconLabelComponent(
        icon: Image
    ) -> some View {
        icon
            .resizable()
            .scaledToFit()
            .frame(size: uiModel.iconSize)
            .foregroundColor(uiModel.iconColors.value(for: internalState))
            .opacity(uiModel.iconOpacities.value(for: internalState))
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
    private static var icon: Image { .init(systemName: "swift") }
    private static var title: String { "Lorem Ipsum".pseudoRTL(languageDirection) }

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
                VMenu(
                    title: title,
                    sections: menuSections
                )

                VMenu(
                    icon: icon,
                    sections: menuSections
                )
            })
        }

        @VMenuSectionBuilder func menuSections() -> [any VMenuSectionProtocol] {
            VMenuGroupSection(headerTitle: "Section 1", rows: {
                VMenuRow(action: {}, title: "One")
                VMenuRow(action: {}, title: "Two", icon: Image(systemName: "swift"))
                VMenuExpandingRow(title: "Three...", sections: {
                    VMenuGroupSection(rows: {
                        VMenuRow(action: {}, title: "One")
                        VMenuRow(action: {}, title: "Two", icon: Image(systemName: "swift"))
                    })
                })
            })

            VMenuPickerSection(selection: $selection)
        }
    }
}
