//
//  VRollingCounterComponentProtocol.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 25.08.23.
//

import Foundation

nonisolated protocol VRollingCounterComponentProtocol {
    var id: String { get }
    var stringRepresentation: String { get }

    var isHighlighted: Bool { get set }
}

nonisolated extension VRollingCounterComponentProtocol {
    static func generateID() -> String {
        UUID().uuidString
    }
}
