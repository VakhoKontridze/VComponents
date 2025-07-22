//
//  VFetchingAsyncImageContent.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 06.03.23.
//

import SwiftUI

// MARK: - V Fetching Async Image Content
enum VFetchingAsyncImageContent<CustomContent, CustomPlaceholderContent>
    where
        CustomContent: View,
        CustomPlaceholderContent: View
{
    case auto
    
    case content(
        contentBuilder: (Image) -> CustomContent
    )
    
    case contentAndPlaceholder(
        contentBuilder: (Image) -> CustomContent,
        placeholderBuilder: () -> CustomPlaceholderContent
    )
    
    case contentWithPhase(
        contentBuilder: (AsyncImagePhase) -> CustomContent
    )
}
