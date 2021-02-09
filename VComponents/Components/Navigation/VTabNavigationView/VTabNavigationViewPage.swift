//
//  VTabNavigationViewPage.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/26/20.
//

import SwiftUI

// MARK:- V Tab Navigation View Page
/// Data source that creates tab navigation item and content
public struct VTabNavigationViewPage<Content> where Content: View {
    // MARK: Properties
    /// Tab page
    public var item: VTabNavigationPageItem
    
    /// Tab content
    public var content: Content
    
    // MARK: Initializers
    /// Initializes data source with item and content
    public init(
        item: VTabNavigationPageItem,
        content: Content
    ) {
        self.item = item
        self.content = content
    }
}
