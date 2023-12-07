//
//  VTappableTextButtonComponent.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 07.12.23.
//

import SwiftUI

// MARK: - V Tappable Text Button Component
/// Button component for `VTappableText`.
public struct VTappableTextButtonComponent: VTappableTextComponentProtocol {
    // MARK: Properties
    private let uiModel: VTappableTextButtonComponentUIModel

    private let title: String
    private let action: () -> Void

    private let urlStringID: UUID
    private let urlString: String

    // MARK: Initializers
    /// Initializes `VTappableTextButtonComponent` with title and action.
    public init(
        uiModel: VTappableTextButtonComponentUIModel = .init(),
        title: String,
        action: @escaping () -> Void
    ) {
        self.uiModel = uiModel
        
        self.title = title
        self.action = action
        
        self.urlStringID = UUID()
        self.urlString = "https://v-tappable-text-button-component.com/\(urlStringID)"
    }

    // MARK: Tappable Text Component Protocol
    public func makeAttributedString() -> AttributedString {
        var attributedString: AttributedString = .init(title)

        attributedString.foregroundColor = uiModel.color
        attributedString.font = uiModel.font
        attributedString.link = URL(string: urlString)

        return attributedString
    }

    // MARK: API
    func isButtonWithURL(_ url: URL) -> Bool {
        urlString == url.absoluteString.removingPercentEncoding
    }

    func callAction() {
        action()
    }
}
