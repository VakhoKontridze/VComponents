//
//  VToggleLabel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 3/1/22.
//

import SwiftUI

// MARK: - V Toggle Label
enum VToggleLabel<CustomLabel> where CustomLabel: View {
    case empty
    case title(title: String)
    case custom(label: () -> CustomLabel)
}
