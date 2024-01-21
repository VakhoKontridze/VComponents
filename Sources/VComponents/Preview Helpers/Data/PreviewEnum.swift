//
//  PreviewEnum.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 21.01.24.
//

#if DEBUG

import SwiftUI

// MARK: - Preview Enum (Weekday)
enum PreviewEnumWeekday: Int, Hashable, Identifiable, CaseIterable {
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

// MARK: - Preview Enum (RGB Color)
enum PreviewEnumRGBColor: Int, Hashable, Identifiable, CaseIterable {
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
