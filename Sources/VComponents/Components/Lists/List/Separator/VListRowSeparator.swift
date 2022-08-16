//
//  VListRowSeparator.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 16.08.22.
//

import SwiftUI

// MARK: - V List Row Separator
/// Separator used in `VListRow`.
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
public struct VListRowSeparator: View {
    // MARK: Properties
    private let uiModel: VListRowSeparatorUIModel
    
    // MARK: Initializers
    /// Initializes component.
    public init(
        uiModel: VListRowSeparatorUIModel = .init()
    ) {
        self.uiModel = uiModel
    }
    
    // MARK: Body
    public var body: some View {
        uiModel.colors.separator
            .frame(maxWidth: .infinity)
            .frame(height: uiModel.layout.height)
            .padding(uiModel.layout.margins)
    }
}

// MARK: - Preview
struct VListRowSeparator_Previews: PreviewProvider {
    static var previews: some View {
        VListRow_Previews.previews
    }
}
