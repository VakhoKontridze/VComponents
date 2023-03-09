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
///                 .padding()
///         })
///     }
///
public struct VSheet<Content>: View where Content: View {
    // MARK: Properties
    private let uiModel: VSheetUIModel
    private let content: VSheetContent<Content>
    
    // MARK: Initializers
    /// Initializes `VSheet` with content.
    public init(
        uiModel: VSheetUIModel = .init(),
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.uiModel = uiModel
        self.content = .content(content: content)
    }
    
    /// Initializes `VSheet`.
    public init(
        uiModel: VSheetUIModel = .init()
    )
        where Content == Never
    {
        self.uiModel = uiModel
        self.content = .empty
    }

    // MARK: Body
    public var body: some View {
        contentView
            .background(sheet)
            .cornerRadius(
                uiModel.layout.cornerRadius,
                corners: uiModel.layout.roundedCorners
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
            .padding(uiModel.layout.contentMargin)
    }
}

// MARK: - Preview
struct VSheet_Previews: PreviewProvider {
    static var previews: some View {
        ColorSchemePreview(title: nil, content: Preview.init)
    }
    
    private struct Preview: View {
        var body: some View {
            PreviewContainer(hasLayer: false, content: {
                VSheet(content: {
                    VText(
                        type: .multiLine(alignment: .center, lineLimit: nil),
                        color: ColorBook.primary,
                        font: .body,
                        text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla dapibus volutpat enim, vitae blandit justo iaculis sit amet. Aenean vitae leo tincidunt, sollicitudin mauris a, mollis massa. Sed posuere, nibh non fermentum ultrices, ipsum nunc luctus arcu, a auctor velit nisl ac nibh. Donec vel arcu condimentum, iaculis quam sed, commodo orci."
                    )
                })
                    .padding()
            })
        }
    }
}
