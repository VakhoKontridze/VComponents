//
//  Logger.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12.02.24.
//

import Foundation
import OSLog

nonisolated extension Logger {
    static let `default`: Self = .init(subsystem: "VComponents", category: "VComponents")
}
