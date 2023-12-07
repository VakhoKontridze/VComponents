//
//  VFetchingAsyncImageContent.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 10.03.23.
//

import SwiftUI

// MARK: - Fetching Async Image Content
enum VFetchingAsyncImageContent<Content, PlaceholderContent>
    where
        Content: View,
        PlaceholderContent: View
{
    case empty
    
    case content(
        content: (Image) -> Content
    )
    
    case contentPlaceholder(
        content: (Image) -> Content,
        placeholder: () -> PlaceholderContent
    )
    
    case contentWithPhase(
        content: (AsyncImagePhase) -> Content
    )
}
