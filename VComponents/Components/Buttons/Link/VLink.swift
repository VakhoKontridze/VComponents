//
//  VLink.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/7/21.
//

import SwiftUI

// MARK: - V Link
/// Button component that controls a navigation presentation to an URL.
///
/// Button is meant to be used with button components from the library.
///
/// Model can be passed as parameter.
///
/// Usage example:
///
///     VLink(
///         url: .init(string: "https://www.apple.com")!,
///         content: {
///             VSecondaryButton(
///                 action: {},
///                 title: "Lorem Ipsum"
///             )
///         }
///     )
///
public struct VLink<Content>: View where Content: View {
    // MARK: Properties
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    private let url: URL
    private let content: () -> Content

    // MARK: Initializers
    /// Initializes component with url and content.
    public init(
        url: URL,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.url = url
        self.content = content
    }

    // MARK: Body
    public var body: some View {
        Link(
            destination: url,
            label: content
        )
            .buttonStyle(.plain) // Cancels styling
            .disabled(!isEnabled)
    }
}

// MARK: - Preview
struct VLink_Previews: PreviewProvider {
    static var previews: some View {
        VLink(
            url: .init(string: "https://www.apple.com")!,
            content: {
                VSecondaryButton(
                    action: {},
                    title: "Lorem Ipsum"
                )
            }
        )
    }
}
