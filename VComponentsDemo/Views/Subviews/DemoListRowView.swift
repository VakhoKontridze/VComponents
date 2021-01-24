//
//  HomeRowView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI
import VComponents

// MARK:- Demo List Row View
struct DemoListRowView<Content>: View where Content: View {
    // MARK: Properties
    private let rowType: RowType
    enum RowType {
        case link(_ destination: Content)
        case custom(_ action: () -> Void)
    }

    private let title: String

    private let chevronButtonModel: VChevronButtonModel = {
        var model: VChevronButtonModel = .init()

        model.colors.content.enabled = .init("ChevronButtonPlain.Foreground.enabled")
        model.colors.content.pressed = .init("ChevronButtonPlain.Foreground.enabled")
        model.colors.content.disabled = .init("ChevronButtonPlain.Foreground.enabled")

        model.colors.background.enabled = .clear
        model.colors.background.pressed = .clear
        model.colors.background.disabled = .clear

        return model
    }()

    // MARK: Initalizers
    init(title: String, destination: Content) {
        self.title = title
        self.rowType = .link(destination)
    }

    init(
        title: String, action: @escaping () -> Void
    )
        where Content == Never
    {
        self.title = title
        self.rowType = .custom(action)
    }
}

// MARK:- Body
extension DemoListRowView {
    @ViewBuilder var body: some View {
        switch rowType {
        case .link(let destination): VNavigationLink(destination: destination, label: { rowView })
        case .custom(let action): Button(action: action, label: { rowView })
        }
    }

    private var rowView: some View {
        HStack(spacing: 0, content: {
            VText(
                type: .oneLine,
                font: .body,
                color: ColorBook.primary,
                title: title
            )

            Spacer()

            VChevronButton(model: chevronButtonModel, direction: .right, action: {})
        })
            .contentShape(Rectangle())
    }
}

// MARK:- Preview
struct DemoListRowView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView_Previews.previews
    }
}
