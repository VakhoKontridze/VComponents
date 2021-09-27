//
//  VBaseViewNavigationBarLeading.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI

// MARK: - Modifier
extension View {
    func setUpBaseViewNavigationBarLeading<LeadingItem, Title, TrailingItem>(
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
        modifier(VBaseViewNavigationBarLeading(
            model: model,
            titleContent: titleContent,
            leadingItemContent: leadingItemContent,
            trailingItemContent: trailingItemContent,
            showBackButton: showBackButton,
            onBack: backAction
        ))
    }
}

// MARK: - V Base View Navigation Bar Leading
struct VBaseViewNavigationBarLeading<TrailingItem, Title, LeadingItem>: ViewModifier
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

    // MARK: Body
    func body(content: Content) -> some View {
        content
            .toolbar(content: { ToolbarItem(placement: .principal, content: { items }) })
    }

    private var items: some View {
        HStack(spacing: model.layout.navBarSpacing, content: {
            if let leadingItemContent = leadingItemContent { leadingItemContent().layoutPriority(1) }

            if showBackButton { VChevronButton(model: model.backButtonSubModel, direction: .left, action: backAction).layoutPriority(1) }

            titleContent().layoutPriority(0)

            Spacer().layoutPriority(0)

            if let trailingItemContent = trailingItemContent { trailingItemContent().layoutPriority(1) }
        })
            .lineLimit(1)
            .padding(.trailing, vHalfModalNavigationViewCloseButton ? VHalfModalModel.Layout.navBarTrailingItemMarginTrailing : 0)
            .frame(width: model.layout.width)
    }
}
