//
//  VActionSheet.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/1/21.
//

import SwiftUI

// MARK: - V Action Sheet
/// Modal component that presents bottom sheet menu of actions.
///
/// Description can be passed as parameter.
///
/// `vActionSheet` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
///
/// Usage example:
///
///     @State var isPresented: Bool = false
///
///     var body: some View {
///         VPlainButton(
///             action: { isPresented = true },
///             title: "Present"
///         )
///             .vActionSheet(isPresented: $isPresented, actionSheet: {
///                 VActionSheet(
///                     title: "Lorem ipsum dolor sit amet",
///                     description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
///                     rows: [
///                         .titled(action: {}, title: "One"),
///                         .titled(action: {}, title: "Two"),
///                         .destructive(action: {}, title: "Three"),
///                         .cancel(title: "Cancel")
///                     ]
///                 )
///             })
///     }
///
public struct VActionSheet {
    // MARK: Properties
    fileprivate let title: String?
    fileprivate let description: String?
    fileprivate let actions: [VActionSheetButton]
    
    // MARK: Initializrs
    /// Initializes component with title, description, and rows.
    public init(
        title: String?,
        description: String?,
        actions: [VActionSheetButton]
    ) {
        self.title = title
        self.description = description
        self.actions = actions
    }
}

// MARK: - Extension
extension View {
    /// Presents `VActionSheet` when boolean is `true`.
    public func vActionSheet(
        isPresented: Binding<Bool>,
        actionSheet: @escaping () -> VActionSheet
    ) -> some View {
        let actionSheet = actionSheet()
        let actions: [VActionSheetButton] = VActionSheetButton.process(actionSheet.actions)

        return self
            .confirmationDialog(
                actionSheet.title ?? "",
                isPresented: isPresented,
                titleVisibility: {
                    switch (actionSheet.title, actionSheet.description) {
                    case (nil, nil): return .hidden
                    case (nil, _?): return .visible
                    case (_?, nil): return .visible
                    case (_?, _?): return .visible
                    }
                }(),
                actions: {
                    ForEach(actions.indices, id: \.self, content: { i in
                        actions[i].swiftUIButton
                    })
                },
                message: {
                    if let description = actionSheet.description {
                        Text(description)
                    }
                }
            )
    }
}
