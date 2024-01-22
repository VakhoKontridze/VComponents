//
//  VTappableText.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 07.12.23.
//

import SwiftUI
import VCore

// MARK: - V Tappable Text
/// Text component with tappable parts.
///
///     VTappableText([
///         VTappableTextTextComponent(text: "Lorem ipsum dolor sit amet, consectetur adipiscing "),
///         VTappableTextButtonComponent(title: "elit", action: { ... }),
///         VTappableTextTextComponent(text: ".")
///     ])
///     .multilineTextAlignment(.center)
///
public struct VTappableText: View {
    // MARK: Properties
    private let components: [any VTappableTextComponentProtocol]

    // MARK: Initializers
    /// Initializes `VTappableText` with components.
    public init(
        _ components: [any VTappableTextComponentProtocol]
    ) {
        self.components = components
    }

    // MARK: Body
    public var body: some View {
        Text(makeAttributedString())
            .environment(\.openURL, OpenURLAction(handler: { url in
                guard
                    let button = components.firstElement(
                        ofType: VTappableTextButtonComponent.self,
                        where: { $0.isButtonWithURL(url) }
                    )
                else {
                    return OpenURLAction.Result.discarded
                }

                button.callAction()
                return OpenURLAction.Result.handled
            }))
    }

    // MARK: Attributed String
    private func makeAttributedString() -> AttributedString {
        var attributedString: AttributedString = .init()

        for component in components {
            attributedString.append(component.makeAttributedString())
        }

        return attributedString
    }
}

// MARK: - Preview
#if DEBUG

#Preview(body: {
    struct ContentView: View {
        @State private var count: Int = 0

        var body: some View {
            PreviewContainer(content: {
                VTappableText([
                    VTappableTextTextComponent(text: "Lorem ipsum dolor sit amet, consectetur adipiscing "),
                    VTappableTextButtonComponent(title: "elit", action: { count += 1 }),
                    VTappableTextTextComponent(text: ".")
                ])
                .multilineTextAlignment(.center)

                Text("\(count)")
            })
        }
    }

    return ContentView()
})

#endif
