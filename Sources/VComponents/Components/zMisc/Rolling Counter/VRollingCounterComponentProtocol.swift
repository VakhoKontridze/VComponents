//
//  VRollingCounterComponentProtocol.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 25.08.23.
//

import Foundation

// MARK: - V Rolling Counter Component Protocol
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
protocol VRollingCounterComponentProtocol {
    var id: String { get }
    var stringRepresentation: String { get }

    var isHighlighted: Bool { get set }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension VRollingCounterComponentProtocol {
    static func generateID() -> String {
        UUID().uuidString
    }
}
