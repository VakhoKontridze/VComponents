//
//  VLink.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/7/21.
//

import SwiftUI

// MARK:- V Link
/// Button component that controls a navigation presentation to an URL
///
/// Component can be initialized with content or title.
///
/// Component supports presets or existing button types.
///
/// State can be passed as parameter
///
/// # Usage Example #
///
/// ```
/// var body: some View {
///     VLink(
///         preset: .secondary(),
///         url: URL(string: "https://www.apple.com"),
///         title: "Lorem ipsum"
///     )
/// }
/// ```
///
public struct VLink<Label>: View where Label: View {
    // MARK: Properties
    @Environment(\.openURL) private var openURL: OpenURLAction
    
    private let linkButtonType: VLinkType
    private let state: VLinkState
    private let url: URL?
    private let label: () -> Label
    
    // MARK: Initializers: Preset
    public init(
        preset linkPreset: VLinkPreset,
        state: VLinkState = .enabled,
        url: URL?,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.linkButtonType = linkPreset.buttonType
        self.state = state
        self.url = url
        self.label = label
    }
    
    public init(
        preset linkPreset: VLinkPreset,
        state: VLinkState = .enabled,
        url: URL?,
        title: String
    )
        where Label == VText
    {
        self.init(
            preset: linkPreset,
            state: state,
            url: url,
            label: { linkPreset.text(from: title, isEnabled: state.isEnabled) }
        )
    }
    
    // MARK: Initializers: Custom
    public init(
        state: VLinkState = .enabled,
        url: URL?,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.linkButtonType = .custom
        self.state = state
        self.url = url
        self.label = label
    }
}

// MARK:- Body
extension VLink {
    public var body: some View {
        VLinkType.linkButton(
            buttonType: linkButtonType,
            isEnabled: state.isEnabled,
            action: action,
            label: label
        )
    }
}

// MARK:- Actions
private extension VLink {
    func action() {
        guard let url = url else { return }
        openURL(url)
    }
}

// MARK:- Preview
struct VLink_Previews: PreviewProvider {
    static var previews: some View {
        VLink(
            preset: .secondary(),
            url: URL(string: "https://www.apple.com"),
            title: "Lorem ipsum"
        )
    }
}
