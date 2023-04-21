//
//  VSheet.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI
import VCore

// MARK: - V Sheet
/// Container component that draws a background and hosts content.
///
/// UI Model can be passed as parameter.
///
/// If content is passed during `init`, `VSheet` would resize according to the size of the content. If content is not passed, `VSheet` would expand to occupy maximum space.
///
///     var body: some View {
///         ZStack(content: {
///             ColorBook.canvas.ignoresSafeArea()
///
///             VSheet(content: {
///                 VText(
///                     type: .multiLine(alignment: .center, lineLimit: nil),
///                     color: ColorBook.primary,
///                     font: .body,
///                     text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla dapibus volutpat enim, vitae blandit justo iaculis sit amet. Aenean vitae leo tincidunt, sollicitudin mauris a, mollis massa. Sed posuere, nibh non fermentum ultrices, ipsum nunc luctus arcu, a auctor velit nisl ac nibh. Donec vel arcu condimentum, iaculis quam sed, commodo orci."
///                 )
///
///             })
///             .padding()
///         })
///     }
///
public struct VSheet<Content>: View where Content: View {
    // MARK: Properties
    @Environment(\.layoutDirection) private var layoutDirection: LayoutDirection
    
    private let uiModel: VSheetUIModel
    private let content: VSheetContent<Content>
    
    // MARK: Initializers
    /// Initializes `VSheet`.
    public init(
        uiModel: VSheetUIModel = .init()
    )
        where Content == Never
    {
        self.uiModel = uiModel
        self.content = .empty
    }
    
    /// Initializes `VSheet` with content.
    public init(
        uiModel: VSheetUIModel = .init(),
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.uiModel = uiModel
        self.content = .content(content: content)
    }
    
    // MARK: Body
    public var body: some View {
        contentView
            .background(sheet)
            .cornerRadius(
                uiModel.layout.cornerRadius,
                corners: uiModel.layout.roundedCorners
                    .withReversedLeftAndRightCorners(
                        uiModel.layout.reversesLeftAndRightCornersForRTLLanguages &&
                        layoutDirection == .rightToLeft
                    )
            )
    }
    
    private var sheet: some View {
        uiModel.colors.background
    }
    
    private var contentView: some View {
        Group(content: {
            switch content {
            case .empty:
                Color.clear
                
            case .content(let content):
                content()
            }
        })
        .padding(uiModel.layout.contentMargins)
    }
}

// MARK: - Preview
// Developmental only
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
struct VSheet_Previews: PreviewProvider {
    // Configuration
    private static var languageDirection: LayoutDirection { .leftToRight }
    private static var dynamicTypeSize: DynamicTypeSize? { nil }
    private static var colorScheme: ColorScheme { .light }
    
    // Previews
    static var previews: some View {
        Group(content: {
            Preview().previewDisplayName("*")
        })
        .environment(\.layoutDirection, languageDirection)
        .applyIfLet(dynamicTypeSize, transform: { $0.dynamicTypeSize($1) })
        .colorScheme(colorScheme)
    }
    
    // Previews (Scenes)
    private struct Preview: View {
        var body: some View {
            PreviewContainer(hasLayer: false, content: {
                VSheet(content: {
                    VText(
                        type: .multiLine(alignment: .center, lineLimit: nil),
                        color: ColorBook.primary,
                        font: .body,
                        text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla dapibus volutpat enim, vitae blandit justo iaculis sit amet. Aenean vitae leo tincidunt, sollicitudin mauris a, mollis massa. Sed posuere, nibh non fermentum ultrices, ipsum nunc luctus arcu, a auctor velit nisl ac nibh. Donec vel arcu condimentum, iaculis quam sed, commodo orci.".pseudoRTL(languageDirection)
                    )
                })
                .padding()
            })
        }
    }
}
