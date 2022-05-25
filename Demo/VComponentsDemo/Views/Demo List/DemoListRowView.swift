//
//  HomeRowView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI
import VComponents

// MARK: - Demo List Row View
struct DemoListRowView<Content>: View where Content: View {
    // MARK: Properties
    private let rowType: RowType
    enum RowType {
        case link(_ destination: Content)
        case custom(_ action: () -> Void)
    }

    private let title: String

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

    // MARK: Body
    @ViewBuilder var body: some View {
        switch rowType {
        case .link(let destination): VNavigationLink(destination: { destination }, label: { row })
        case .custom(let action): Button(action: action, label: { row })
        }
    }

    private var row: some View {
        HStack(spacing: 0, content: {
            VText(
                color: ColorBook.primary,
                font: .body,
                text: title
            )

            Spacer()

            Image("Chevron.Up", bundle: nil)
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(dimension: 14)
                .rotationEffect(.degrees(90))
        })
            .contentShape(Rectangle())
            .padding(.vertical, 5)
    }
}

// MARK: - Preview
struct DemoListRowView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView_Previews.previews
    }
}
