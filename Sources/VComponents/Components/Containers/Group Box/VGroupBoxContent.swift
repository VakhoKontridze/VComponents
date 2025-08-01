//
//  VGroupBoxContent.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 4/13/22.
//

import SwiftUI

enum VGroupBoxContent<Content> where Content: View {
    case empty
    case content(content: () -> Content)
}
