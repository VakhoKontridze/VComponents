//
//  VPrimaryButtonLabel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/26/22.
//

import SwiftUI

// MARK: - V Primary Button Label
enum VPrimaryButtonLabel<CustomLabel> where CustomLabel: View {
    case title(title: String)
    case iconTitle(icon: Image, title: String)
    case custom(label: () -> CustomLabel)
}
