//
//  VTabNavigationViewPage.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI

// MARK:- V Tab Navigation View Page
/// Data source that creates tab navigation item and content
public struct VTabNavigationViewPage<Content, ItemContent>
    where
        Content: View,
        ItemContent: View
{
    // MARK: Properties
    public var item: ItemContent
    public var content: Content
    
    // MARK: Initializers
    /// Initializes data source
    ///
    /// ```
    /// func item(_ title: String) -> some View {
    ///     VStack(spacing: 5, content: {
    ///         Image(systemName: "swift")
    ///             .resizable()
    ///             .frame(width: 20, height: 20)
    ///
    ///         Text(title)
    ///     })
    /// }
    ///
    /// var body: some View {
    ///     VTabNavigationViewPage(
    ///         item: item("Red"),
    ///         content: Color.red
    ///     )
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - item: Tab item content
    ///   - content: Tab content
    public init(
        item: ItemContent,
        content: Content
    ) {
        self.item = item
        self.content = content
    }
}
