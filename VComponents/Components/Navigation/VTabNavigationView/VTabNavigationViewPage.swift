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
    public init(
        item: ItemContent,
        content: Content
    ) {
        self.item = item
        self.content = content
    }
}
