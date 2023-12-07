//
//  VTappableTextTextComponent.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 07.12.23.
//

import SwiftUI

// MARK: - V Tappable Paragraph Text
/// Text component for `VTappableText`.
public struct VTappableTextTextComponent: VTappableTextComponentProtocol {
    // MARK: Properties
    private let uiModel: VTappableTextTextComponentUIModel
    private let text: String

    // MARK: Initializers
    /// Initializes `VTappableTextTextComponent` with text.
    public init(
        uiModel: VTappableTextTextComponentUIModel = .init(),
        text: String
    ) {
        self.uiModel = uiModel
        self.text = text
    }

    // MARK: Tappable Text Component Protocol
    public func makeAttributedString() -> AttributedString {
        var attributedString: AttributedString = .init(text)

        attributedString.foregroundColor = uiModel.color
        attributedString.font = uiModel.font

        return attributedString
    }
}
