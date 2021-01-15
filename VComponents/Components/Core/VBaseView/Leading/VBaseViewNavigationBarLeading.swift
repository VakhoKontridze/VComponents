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
        model: VBaseViewModelLeading,
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
    private let title: String
    private let model: VBaseViewModelLeading
    
    private let leadingItemContent: (() -> LeadingItem)?
    private let trailingItemContent: (() -> TrailingItem)?
    
    private let showBackButton: Bool
    private let backAction: () -> Void
    
    // MARK: Initializers
    init(
        model: VBaseViewModelLeading,
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

            if showBackButton { VChevronButton(direction: .left, action: backAction).layoutPriority(1) }

            VBaseTitle(
                title: title,
                color: model.titleColor,
                font: model.font,
                type: .oneLine
            )
                .layoutPriority(0)

            Spacer()

            if let trailingItemContent = trailingItemContent { trailingItemContent().layoutPriority(1) }
        })
            .lineLimit(1)
            .frame(width: model.layout.width)
    }
}
