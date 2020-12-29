//
//  VTabNavigationViewPage.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI

// MARK:- V Tab Navigation View Page
public struct VTabNavigationViewPage<Content, ItemContent>
    where
        Content: View,
        ItemContent: View
{
    // MARK: Properties
    public let item: ItemContent
    public let content: Content
    
    // MARK: Initializers
    public init(
        item: ItemContent,
        content: Content
    ) {
        self.item = item
        self.content = content
    }
}
