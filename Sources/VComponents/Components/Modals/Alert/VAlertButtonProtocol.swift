//
//  VAlertButtonProtocol.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 01.05.23.
//

import SwiftUI

// MARK: - V Alert Button Protocol
/// `VAlert` button protocol.
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public protocol VAlertButtonProtocol: VAlertButtonConvertible {
    /// Body type.
    typealias Body = AnyView

    /// Creates a `View` that represents the body of a button.
    @MainActor
    func makeBody(
        uiModel: VAlertUIModel,
        animateOutHandler: @escaping (/*completion*/ (() -> Void)?) -> Void
    ) -> Body
}

@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension VAlertButtonProtocol {
    public func toButtons() -> [any VAlertButtonProtocol] { [self] }
}
