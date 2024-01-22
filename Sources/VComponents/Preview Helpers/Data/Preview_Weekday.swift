//
//  Preview_Weekday.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 21.01.24.
//

#if DEBUG

import SwiftUI

// MARK: - Weekday
enum Preview_Weekday: Int, Hashable, Identifiable, CaseIterable {
    // MARK: Cases
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday

    // MARK: Properties
    var title: String { .init(describing: self).capitalized }

    var color: Color {
        switch rawValue.remainderReportingOverflow(dividingBy: 3).0 {
        case 0: Color.red
        case 1: Color.green
        case 2: Color.blue
        default: fatalError()
        }
    }

    // MARK: Identifiable
    var id: Int { rawValue }
}

#endif
