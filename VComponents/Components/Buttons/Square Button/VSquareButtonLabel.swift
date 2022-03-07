//
//  VSquareButtonLabel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/27/22.
//

import SwiftUI

// MARK: - V Square Button Label
enum VSquareButtonLabel<CustomLabel> where CustomLabel: View {
    case title(title: String)
    case icon(icon: Image)
    case custom(label: () -> CustomLabel)
}
