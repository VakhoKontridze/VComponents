//
//  SwiftUIViewTypeDescriber.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 26.05.22.
//

import SwiftUI

// MARK: - Swift UI Type Describer
struct SwiftUIViewTypeDescriber {
    private init() {}
    
    static func describe<Content>(
        _ content: Content
    ) -> String
        where Content: View
    {
        String(describing: type(of: content.body))
    }
}
