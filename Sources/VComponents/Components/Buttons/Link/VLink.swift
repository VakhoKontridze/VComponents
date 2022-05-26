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
///     var body: some View {
///         VLink(
///             url: .init(string: "https://www.apple.com")!,
///             label: {
///                 VSecondaryButton(
///                 action: {},
///                 title: "Lorem Ipsum"
///                 )
///             }
///         )
///     }
///
public struct VLink<Label>: View where Label: View {
    // MARK: Properties
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    private let url: URL
    private let label: () -> Label

    // MARK: Initializers
    /// Initializes component with url and label.
    public init(
        url: URL,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.url = url
        self.label = label
    }

    // MARK: Body
    public var body: some View {
        Link(
            destination: url,
            label: label
        )
            .buttonStyle(.plain) // Cancels styling
            .disabled(!isEnabled)
    }
}

// MARK: - Preview
struct VLink_Previews: PreviewProvider {
    static var previews: some View {
        VLink(
            url: .init(string: "https://www.apple.com")!, // fatalError
            label: {
                VSecondaryButton(
                    action: {},
                    title: "Lorem Ipsum"
                )
            }
        )
    }
}
