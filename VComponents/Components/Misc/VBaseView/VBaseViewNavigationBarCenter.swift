//
//  VBaseViewNavigationBarCenter.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK:- Modifier
extension View {
    func setUpBaseViewNavigationBarCenter<LeadingItem, Title, TrailingItem>(
        model: VBaseViewModel,
        @ViewBuilder titleContent: @escaping () -> Title,
        leadingItemContent: (() -> LeadingItem)?,
        trailingItemContent: (() -> TrailingItem)?,
        showBackButton: Bool,
        onBack backAction: @escaping () -> Void
    ) -> some View
        where
            LeadingItem: View,
            Title: View,
            TrailingItem: View
    {
        modifier(VBaseViewNavigationBarCenter(
            model: model,
            titleContent: titleContent,
            leadingItemContent: leadingItemContent,
            trailingItemContent: trailingItemContent,
            showBackButton: showBackButton,
            onBack: backAction
        ))
    }
}

// MARK:- V Base View Navigation Bar Center
struct VBaseViewNavigationBarCenter<TrailingItem, Title, LeadingItem>: ViewModifier
    where
        LeadingItem: View,
        Title: View,
        TrailingItem: View
{
    // MARK: Properties
    @Environment(\.vHalfModalNavigationViewCloseButton) private var vHalfModalNavigationViewCloseButton: Bool
    
    private let model: VBaseViewModel
    
    private let titleContent: () -> Title
    private let leadingItemContent: (() -> LeadingItem)?
    private let trailingItemContent: (() -> TrailingItem)?

    private let showBackButton: Bool
    private let backAction: () -> Void

    @State private var leadingWidth: CGFloat = .zero
    @State private var trailingWidth: CGFloat = .zero
    private var leadingTrailingWidth: CGFloat? {
        let max: CGFloat? = [leadingWidth, trailingWidth].max()
        return max != .zero ? max : nil
    }
    
    // MARK: Initializers
    init(
        model: VBaseViewModel,
        @ViewBuilder titleContent: @escaping () -> Title,
        leadingItemContent: (() -> LeadingItem)?,
        trailingItemContent: (() -> TrailingItem)?,
        showBackButton: Bool,
        onBack backAction: @escaping () -> Void
    ) {
        self.model = model
        self.titleContent = titleContent
        self.leadingItemContent = leadingItemContent
        self.trailingItemContent = trailingItemContent
        self.showBackButton = showBackButton
        self.backAction = backAction
    }
}

// MARK:- Body
extension VBaseViewNavigationBarCenter {
    func body(content: Content) -> some View {
        content
            .toolbar(content: { ToolbarItem(placement: .principal, content: { items }) })
    }

    private var items: some View {
        HStack(spacing: 0, content: {
            HStack(spacing: model.layout.navBarSpacing, content: {
                if let leadingItemContent = leadingItemContent { leadingItemContent() }

                if showBackButton { VChevronButton(model: model.backButtonSubModel, direction: .left, action: backAction) }
            })
                .frame(minWidth: leadingTrailingWidth, alignment: .leading)
                .layoutPriority(1)
                .readSize(onChange: { leadingWidth = $0.width })

            Spacer()

            HStack(spacing: model.layout.navBarSpacing, content: {
                titleContent()
            })

            Spacer()

            HStack(spacing: model.layout.navBarSpacing, content: {
                if let trailingItemContent = trailingItemContent { trailingItemContent() }
            })
                .frame(minWidth: leadingTrailingWidth, alignment: .trailing)
                .layoutPriority(1)
                .readSize(onChange: { trailingWidth = $0.width })
        })
            .lineLimit(1)
            .padding(.trailing, vHalfModalNavigationViewCloseButton ? VHalfModalModel.Layout.navBarTrailingItemMarginTrailing : 0)
            .frame(width: model.layout.width)
    }
}
