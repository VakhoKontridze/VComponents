//
//  VLink.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/7/21.
//

import SwiftUI

// MARK: - V Link
/// Button component that controls a navigation presentation to an `URL`.
///
/// Button is meant to be used with button components from the library.
///
/// UI Model can be passed as parameter.
///
///     var body: some View {
///         VLink(
///             url: .init(string: "https://www.apple.com")!,
///             title: "Lorem Ipsum"
///         )
///     }
///
public struct VLink<Label>: View where Label: View {
    // MARK: Properties
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    private let url: URL
    private let label: VLinkLabel<Label>

    // MARK: Initializers
    /// Initializes component with `URL` and title.
    public init(
        url: URL,
        title: String
    )
        where Label == Never
    {
        self.url = url
        self.label = .title(title: title)
    }
    
    /// Initializes component with `URL` and label.
    public init(
        url: URL,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.url = url
        self.label = .custom(label: label)
    }

    // MARK: Body
    public var body: some View {
        Link(
            destination: url,
            label: buttonLabel
        )
            .buttonStyle(.plain) // Cancels styling
            .disabled(!isEnabled)
    }
    
    @ViewBuilder private func buttonLabel() -> some View {
        switch label {
        case .title(let title):
            VPlainButton(action: {}, title: title)
            
        case .custom(let label):
            label()
        }
    }
}

// MARK: - Preview
struct VLink_Previews: PreviewProvider {
    static var previews: some View {
        VLink(
            url: .init(string: "https://www.apple.com")!, // fatalError
            title: "Lorem Ipsum"
        )
    }
}
