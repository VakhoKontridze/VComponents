//
//  VAccordionHeaderLabel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 4/6/22.
//

import SwiftUI

// MARK: - V Accordion Header Label
enum VAccordionHeaderLabel<CustomHeaderLabel> where CustomHeaderLabel: View {
    case title(title: String)
    case custom(label: () -> CustomHeaderLabel)
}
