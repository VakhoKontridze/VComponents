//
//  VRollingCounterComponentProtocol.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 25.08.23.
//

import Foundation

protocol VRollingCounterComponentProtocol {
    var id: String { get }
    var stringRepresentation: String { get }

    var isHighlighted: Bool { get set }
}

extension VRollingCounterComponentProtocol {
    static func generateID() -> String {
        UUID().uuidString
    }
}
