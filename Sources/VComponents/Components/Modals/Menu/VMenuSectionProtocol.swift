//
//  VMenuSectionProtocol.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 01.05.23.
//

import SwiftUI

// MARK: - V Menu Section Protocol
/// `VMenu` section protocol.
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public protocol VMenuSectionProtocol: VMenuSectionConvertible {
    /// The stable identity of the entity associated with this instance.
    var id: Int { get }

    /// Section header title.
    var headerTitle: String? { get }

    /// Section body type.
    typealias Body = AnyView

    /// Creates a `View` that represents the body of a section.
    func makeBody() -> Body
}

@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VMenuSectionProtocol {
    public func toSections() -> [any VMenuSectionProtocol] { [self] }
}
