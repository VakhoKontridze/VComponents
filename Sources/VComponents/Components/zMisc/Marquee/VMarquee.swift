//
//  VMarquee.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 24.02.23.
//

import SwiftUI

// MARK: - V Marquee
/// Container that automatically scrolls it's content edge-to-edge.
///
/// Type can be passed as parameter.
///
///     var body: some View {
///         VMarquee(
///             type: .wrapping(uiModel: .insettedGradient),
///             content: {
///                 HStack(content: {
///                     Image(systemName: "swift")
///                     Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
///                 })
///                     .drawingGroup() // For Images
///             }
///         )
///     }
///
public struct VMarquee<Content>: View where Content: View {
    // MARK: Properties
    private let marqueeType: VMarqueeType
    private let content: () -> Content
    
    // MARK: Initializers
    /// Initializes component with type and content.
    public init(
        type marqueeType: VMarqueeType = .default,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.marqueeType = marqueeType
        self.content = content
    }
    
    // MARK: Body
    public var body: some View {
        switch marqueeType._marqueeType {
        case .wrapping(let uiModel): VMarqueeWrapping(uiModel: uiModel, content: content)
        case .bouncing(let uiModel): VMarqueeBouncing(uiModel: uiModel, content: content)
        }
    }
}

// MARK: - Preview
struct VMarquee_Previews: PreviewProvider {
    private static var text: String { "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin tempus facilisis risus, ut condimentum diam tempus non." }
    
    static var previews: some View {
        VStack(content: {
            VMarquee(
                type: .wrapping(uiModel: .insettedGradient),
                content: { Text(text) }
            )

            VMarquee(
                type: .bouncing(uiModel: .insettedGradient),
                content: { Text(text) }
            )
        })
    }
}
