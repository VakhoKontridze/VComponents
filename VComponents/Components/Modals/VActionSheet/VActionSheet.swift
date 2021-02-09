//
//  VActionSheet.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/1/21.
//

import SwiftUI

// MARK:- V Action Sheet
/// Modal component that presents half modal menu of actions
///
/// Description can be passed as parameter
///
/// `vActionSheet` modifier can be used on any view down the view hierarchy, as content overlay will always be centered on the screen
///
/// # Usage Example #
///
/// ```
/// @State var isPresented: Bool = false
///
/// var body: some View {
///     VSecondaryButton(action: { isPresented = true }, title: "Present")
///         .vActionSheet(isPresented: $isPresented, actionSheet: {
///             VActionSheet(
///                 title: "Lorem ipsum dolor sit amet",
///                 description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
///                 rows: [
///                     .titled(action: {}, title: "One"),
///                     .titled(action: {}, title: "Two"),
///                     .destructive(action: {}, title: "Three"),
///                     .cancel(title: "Cancel")
///                 ]
///             )
///         })
/// }
/// ```
///
public struct VActionSheet {
    // MARK: Properties
    fileprivate let title: String
    fileprivate let description: String?
    fileprivate let rows: [VActionSheetRow]
    
    // MARK: Initializrs
    /// Initializes component with title, description, and rows
    public init(
        title: String,
        description: String?,
        rows: [VActionSheetRow]
    ) {
        self.title = title
        self.description = description
        self.rows = rows
    }
}

// MARK:- Extension
extension View {
    /// Presents action sheet
    public func vActionSheet(
        isPresented: Binding<Bool>,
        actionSheet: @escaping () -> VActionSheet
    ) -> some View {
        let actionSheet = actionSheet()
        
        return self
            .actionSheet(isPresented: isPresented, content: {
                ActionSheet(
                    title: Text(actionSheet.title),
                    message: {
                        if let description = actionSheet.description {
                            return Text(description)
                        } else {
                            return nil
                        }
                    }(),
                    buttons: actionSheet.rows.map { $0.actionSheetButton }
                )
            })
    }
}
