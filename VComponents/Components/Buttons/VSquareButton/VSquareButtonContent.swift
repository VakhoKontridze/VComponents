//
//  VSquareButtonContent.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/27/22.
//

import SwiftUI

// MARK: - V Square Button Content
enum VSquareButtonContent<CustomContent> where CustomContent: View {
    case title(title: String)
    case icon(icon: Image)
    case content(content: () -> CustomContent)
}
