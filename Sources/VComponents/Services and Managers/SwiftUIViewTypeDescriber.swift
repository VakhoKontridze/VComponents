//
//  SwiftUIViewTypeDescriber.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 26.05.22.
//

import SwiftUI

// MARK: - Swift UI Type Describer
struct SwiftUIViewTypeDescriber {
    // MARK: Initializers
    private init() {}
    
    // MARK: Describe
    static func describe(_ content: some View) -> String {
        if type(of: content).Body.self == Never.self {
            return .init(describing: type(of: content))
        } else {
            return .init(describing: type(of: content.body))
        }
    }
}
