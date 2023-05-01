//
//  VAlertButtonProtocol.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 01.05.23.
//

import SwiftUI

// MARK: - V Alert Button Protocol
/// `VAlert` button protocol.
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public protocol VAlertButtonProtocol: VAlertButtonConvertible {
    /// Body type.
    typealias Body = AnyView

    /// Creates a `View` that represents the body of a button.
    func makeBody(
        uiModel: VAlertUIModel,
        animateOut: @escaping (/*completion*/ (() -> Void)?) -> Void
    ) -> Body
}

@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VAlertButtonProtocol {
    public func toButtons() -> [any VAlertButtonProtocol] { [self] }
}
