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
        customContent: (Image) -> CustomContent
    )
    
    case contentAndPlaceholder(
        customContent: (Image) -> CustomContent,
        customPlaceholderContent: () -> CustomPlaceholderContent
    )
    
    case contentWithPhase(
        customContentWithPhase: (AsyncImagePhase) -> CustomContent
    )
}
