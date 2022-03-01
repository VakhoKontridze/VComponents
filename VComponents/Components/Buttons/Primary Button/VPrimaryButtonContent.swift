//
//  VPrimaryButtonContent.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/26/22.
//

import SwiftUI

// MARK: - V Primary Button Content
enum VPrimaryButtonContent<CustomContent> where CustomContent: View {
    case title(title: String)
    case iconTitle(icon: Image, title: String)
    case content(content: () -> CustomContent)
}
