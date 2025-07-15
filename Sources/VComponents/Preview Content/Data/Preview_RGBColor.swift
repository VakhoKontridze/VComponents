//
//  Preview_RGBColor.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 22.01.24.
//

#if DEBUG

import SwiftUI

// MARK: - RGB Color
enum Preview_RGBColor: Int, Hashable, Identifiable, CaseIterable {
    // MARK: Cases
    case red, green, blue

    // MARK: Properties
    var title: String { .init(describing: self).capitalized }

    var color: Color {
        switch self {
        case .red: Color.red
        case .green: Color.green
        case .blue: Color.blue
        }
    }

    // MARK: Identifiable
    var id: Int { rawValue }
}

#endif
