//
//  VBaseViewNavigationBarLeading.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI

// MARK:- Modifier
extension View {
    func setUpBaseViewNavigationBarLeading<LeadingItem, TrailingItem>(
        model: VBaseViewModel,
        title: String,
        leadingItemContent: (() -> LeadingItem)?,
        trailingItemContent: (() -> TrailingItem)?,
        showBackButton: Bool,
        onBack backAction: @escaping () -> Void
    ) -> some View
        where
            LeadingItem: View,
            TrailingItem: View
    {
        modifier(VBaseViewNavigationBarLeading(
            model: model,
            title: title,
            leadingItemContent: leadingItemContent,
            trailingItemContent: trailingItemContent,
            showBackButton: showBackButton,
            onBack: backAction
        ))
    }
}

// MARK:- V Base View Navigation Bar Leading
struct VBaseViewNavigationBarLeading<TrailingItem, LeadingItem>: ViewModifier
    where
        LeadingItem: View,
        TrailingItem: View
{
    // MARK: Properties
    @Environment(\.vHalfModalNavigationViewCloseButton) private var vHalfModalNavigationViewCloseButton: Bool
    
    private let title: String
    private let model: VBaseViewModel
    
    private let leadingItemContent: (() -> LeadingItem)?
    private let trailingItemContent: (() -> TrailingItem)?
    
    private let showBackButton: Bool
    private let backAction: () -> Void
    
    // MARK: Initializers
    init(
        model: VBaseViewModel,
        title: String,
        leadingItemContent: (() -> LeadingItem)?,
        trailingItemContent: (() -> TrailingItem)?,
        showBackButton: Bool,
        onBack backAction: @escaping () -> Void
    ) {
        self.model = model
        self.title = title
        self.leadingItemContent = leadingItemContent
        self.trailingItemContent = trailingItemContent
        self.showBackButton = showBackButton
        self.backAction = backAction
    }
}

// MARK:- Body
extension VBaseViewNavigationBarLeading {
    func body(content: Content) -> some View {
        content
            .toolbar(content: { ToolbarItem(placement: .principal, content: { items }) })
    }

    private var items: some View {
        HStack(spacing: model.layout.spacing, content: {
            if let leadingItemContent = leadingItemContent { leadingItemContent().layoutPriority(1) }

            if showBackButton { VChevronButton(model: model.backButtonSubModel, direction: .left, action: backAction).layoutPriority(1) }

            VText(
                title: title,
                color: model.colors.titleColor,
                font: model.fonts.title,
                type: .oneLine
            )
                .layoutPriority(0)

            Spacer()

            if let trailingItemContent = trailingItemContent { trailingItemContent().layoutPriority(1) }
        })
            .lineLimit(1)
            .padding(.trailing, vHalfModalNavigationViewCloseButton ? VHalfModalModel.Layout.navigationViewHalfModalCloseButtonMarginTrailing : 0)
            .frame(width: model.layout.width)
    }
}
