//
//  Deprecations.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/12/21.
//

import SwiftUI
import VCore

// MARK: - V Tappable Text
@available(*, deprecated, message: "Use 'AttributedString.init(stringAndDefault:attributeContainers:)' with 'View.onOpenURL(_:perform:)'")
public struct VTappableText: View {
    private let components: [any VTappableTextComponentProtocol]

    public init(
        _ components: [any VTappableTextComponentProtocol]
    ) {
        self.components = components
    }

    public var body: some View {
        Text(makeAttributedString())
            .environment(\.openURL, OpenURLAction(handler: { url in
                guard
                    let button = components.firstElement(
                        ofType: VTappableTextButtonComponent.self,
                        where: { $0.isButtonWithURL(url) }
                    )
                else {
                    return .discarded
                }

                button.callAction()
                return .handled
            }))
    }

    private func makeAttributedString() -> AttributedString {
        var attributedString: AttributedString = .init()

        for component in components {
            attributedString.append(component.makeAttributedString())
        }

        return attributedString
    }
}

@available(*, deprecated, message: "Use 'AttributedString.init(stringAndDefault:attributeContainers:)' with 'View.onOpenURL(_:perform:)'")
public protocol VTappableTextComponentProtocol {
    func makeAttributedString() -> AttributedString
}

@available(*, deprecated, message: "Use 'AttributedString.init(stringAndDefault:attributeContainers:)' with 'View.onOpenURL(_:perform:)'")
public struct VTappableTextTextComponent: VTappableTextComponentProtocol {
    private let uiModel: VTappableTextTextComponentUIModel
    private let text: String

    public init(
        uiModel: VTappableTextTextComponentUIModel = .init(),
        text: String
    ) {
        self.uiModel = uiModel
        self.text = text
    }

    public func makeAttributedString() -> AttributedString {
        var attributedString: AttributedString = .init(text)

        attributedString.foregroundColor = uiModel.color
        attributedString.font = uiModel.font

        return attributedString
    }
}

@available(*, deprecated, message: "Use 'AttributedString.init(stringAndDefault:attributeContainers:)' with 'View.onOpenURL(_:perform:)'")
public struct VTappableTextTextComponentUIModel {
    public var color: Color = .primary
    public var font: Font = .body

    public init() {}
}

@available(*, deprecated, message: "Use 'AttributedString.init(stringAndDefault:attributeContainers:)' with 'View.onOpenURL(_:perform:)'")
public struct VTappableTextButtonComponent: VTappableTextComponentProtocol {
    private let uiModel: VTappableTextButtonComponentUIModel

    private let title: String
    private let action: () -> Void

    private let urlStringID: UUID
    private let urlString: String

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

    public func makeAttributedString() -> AttributedString {
        var attributedString: AttributedString = .init(title)

        attributedString.foregroundColor = uiModel.color
        attributedString.font = uiModel.font
        attributedString.link = URL(string: urlString)

        return attributedString
    }

    func isButtonWithURL(_ url: URL) -> Bool {
        urlString == url.absoluteString.removingPercentEncoding
    }

    func callAction() {
        action()
    }
}

@available(*, deprecated, message: "Use 'AttributedString.init(stringAndDefault:attributeContainers:)' with 'View.onOpenURL(_:perform:)'")
public struct VTappableTextButtonComponentUIModel {
    public var color: Color = {
#if os(iOS)
        Color.blue
#elseif os(macOS)
        Color.blue
#elseif os(tvOS)
        Color.blue
#elseif os(watchOS)
        Color.blue
#elseif os(visionOS)
        Color.primary
#endif
    }()

    public var font: Font = .body.bold()

    public init() {}
}

// MARK: - V Wrapping Marquee
extension VWrappingMarqueeUIModel {
    @available(*, deprecated, renamed: "gradientMaskWidth")
    public var gradientWidth: CGFloat {
        get { gradientMaskWidth }
        set { gradientMaskWidth = newValue }
    }

    @available(*, deprecated, renamed: "insettedGradientMask")
    public static var insettedGradient: Self {
        insettedGradientMask
    }
}

// MARK: - V Bouncing Marquee
extension VBouncingMarqueeUIModel {
    @available(*, deprecated, renamed: "gradientMaskWidth")
    public var gradientWidth: CGFloat {
        get { gradientMaskWidth }
        set { gradientMaskWidth = newValue }
    }

    @available(*, deprecated, renamed: "insettedGradientMask")
    public static var insettedGradient: Self {
        insettedGradientMask
    }
}
