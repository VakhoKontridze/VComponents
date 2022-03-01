//
//  VPlainButtonContent.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/27/22.
//

import SwiftUI

// MARK: - V Plain Button Content
enum VPlainButtonContent<CustomContent> where CustomContent: View {
    case title(title: String)
    case icon(icon: Image)
    case iconTitle(icon: Image, text: String)
    case content(content: () -> CustomContent)
}
