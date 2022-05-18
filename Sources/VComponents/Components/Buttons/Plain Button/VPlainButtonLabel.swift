//
//  VPlainButtonLabel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/27/22.
//

import SwiftUI

// MARK: - V Plain Button Label
enum VPlainButtonLabel<CustomLabel> where CustomLabel: View {
    case title(title: String)
    case icon(icon: Image)
    case iconTitle(icon: Image, text: String)
    case custom(label: () -> CustomLabel)
}
