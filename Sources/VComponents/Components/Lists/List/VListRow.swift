//
//  VListRow.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/10/21.
//

import SwiftUI

// MARK: - V List Row
/// `View` in container that presents rows of data arranged in a single column.
///
/// Component is designed to be used within `List` and `ScrollView`.
/// When creating a `List`, `.vListStyle()` modifier must be applied.
///
/// Component works by inserting `VListRowSeparator` as separators, based on strategy of `VListRowSeparatorType`.
///
/// UI Model can be passed as parameter.
///
/// Default `List` can be created as:
///
///     List(content: {
///         ForEach(titles, id: \.self, content: { title in
///             VListRow(content: {
///                 Text(title)
///             })
///         })
///     })
///         .vListStyle()
///
/// Default `ScrollView` can be created as:
///
///     ScrollView(content: {
///         LazyVStack(spacing: 0, content: {
///             ForEach(titles, id: \.self, content: { title in
///                 VListRow(content: {
///                     Text(title)
///                 })
///             })
///         })
///     })
///
/// "Static list" can be created as:
///
///     LazyVStack(spacing: 0, content: {
///         ForEach(titles, id: \.self, content: { title in
///             VListRow(content: {
///                 Text(title)
///             })
///         })
///     })
///
/// Separators can be removed in the following way:
///
///     List(content: {
///         ForEach(titles, id: \.self, content: { title in
///             VListRow(separator: .none, content: {
///                 Text(title)
///             })
///         })
///     })
///         .vListStyle()
///
/// `iOS` `15`-like enclosed `List` can be created as:
///
///     List(content: {
///         ForEach(titles.enumeratedArray(), id: \.element, content: { (i, title) in
///             VListRow(separator: .rowEnclosingSeparators(isFirst: i == 0), content: {
///                 Text(title)
///             })
///         })
///     })
///         .vListStyle()
///
public struct VListRow<Content>: View
    where Content: View
{
    // MARK: Properties
    private let uiModel: VListRowUIModel
    private let separatorType: VListRowSeparatorType
    private let content: () -> Content
    
    // MARK: Initializers
    /// Initializes component with content.
    public init(
        uiModel: VListRowUIModel = .init(),
        separator separatorType: VListRowSeparatorType = .default,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.uiModel = uiModel
        self.separatorType = separatorType
        self.content = content
    }
    
    // MARK: Body
    public var body: some View {
        VStack(alignment: .leading, spacing: 0, content: {
            if separatorType.contains(.top) { separator }
            
            content()
                .padding(uiModel.layout.margins)
            
            if separatorType.contains(.bottom) { separator }
        })
            .listRowInsets(.init())
            .listRowBackground(uiModel.colors.background)
            .listRowSeparator(.hidden)
    }
    
    private var separator: some View {
        uiModel.colors.separator
            .frame(maxWidth: .infinity)
            .frame(height: uiModel.layout.separatorHeight)
            .padding(uiModel.layout.separatorMargins)
    }
}

// MARK: - Preview
struct VListRow_Previews: PreviewProvider {
    private static var titles: [String] { (0..<10).map { .init($0) } }
    
    static var previews: some View {
        List(content: {
            ForEach(titles, id: \.self, content: { title in
                VListRow(content: {
                    Text(title)
                })
            })
        })
            .vListStyle()
    }
}