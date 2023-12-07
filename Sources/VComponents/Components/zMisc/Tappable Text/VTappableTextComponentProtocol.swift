//
//  VTappableTextComponentProtocol.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 07.12.23.
//

import SwiftUI

// MARK: - V Tappable Text Component Protocol
/// `VTappableText` component protocol.
public protocol VTappableTextComponentProtocol {
    /// Creates `AttributedString`.
    func makeAttributedString() -> AttributedString
}
