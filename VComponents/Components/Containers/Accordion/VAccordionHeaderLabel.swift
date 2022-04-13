//
//  VAccordionHeaderLabel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 4/6/22.
//

import SwiftUI

// MARK: - V Accordion Header
enum VAccordionHeaderLabel<CustomHeaderLabel> where CustomHeaderLabel: View {
    case title(title: String)
    case custom(label: () -> CustomHeaderLabel)
}
