//
//  VBaseViewCenterNavigationBar.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK:- Modifier
extension View {
    func setUpBaseViewCenterNavigationBar<LeadingItem, TrailingItem>(
        model: VBaseViewCenterModel,
        title: String,
        leadingItem: LeadingItem?,
        trailingItem: TrailingItem?,
        onBack backAction: @escaping () -> Void
    ) -> some View
        where
            LeadingItem: View,
            TrailingItem: View
    {
        modifier(VBaseViewCenterNavigationBar(
            model: model,
            title: title,
            leadingItem: leadingItem,
            trailingItem: trailingItem,
            onBack: backAction
        ))
    }
}

// MARK:- V Base View Center Navigation Bar
struct VBaseViewCenterNavigationBar<TrailingItem, LeadingItem>: ViewModifier
    where
        LeadingItem: View,
        TrailingItem: View
{
    // MARK: Properties
    private let title: String
    private let model: VBaseViewCenterModel
    
    private let leadingItem: LeadingItem?
    private let trailingItem: TrailingItem?
    
    private let backAction: () -> Void
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    private var isDestination: Bool { presentationMode.wrappedValue.isPresented }
    
    @State private var leadingWidth: CGFloat = .zero
    @State private var trailingWidth: CGFloat = .zero
    private var leadingTrailingWidth: CGFloat? {
        let max: CGFloat? = [leadingWidth, trailingWidth].max()
        return max != .zero ? max : nil
    }
    
    // MARK: Initializers
    init(
        model: VBaseViewCenterModel,
        title: String,
        leadingItem: LeadingItem?,
        trailingItem: TrailingItem?,
        onBack backAction: @escaping () -> Void
    ) {
        self.model = model
        self.title = title
        self.leadingItem = leadingItem
        self.trailingItem = trailingItem
        self.backAction = backAction
    }
}

// MARK:- Body
extension VBaseViewCenterNavigationBar {
    func body(content: Content) -> some View {
        content
            .toolbar(content: { ToolbarItem(placement: .principal, content: { items }) })
    }

    private var items: some View {
        HStack(spacing: model.layout.spacing, content: {
            HStack(spacing: model.layout.spacing, content: {
                if let leadingItem = leadingItem { leadingItem }

                if isDestination { VChevronButton(direction: .left, action: backAction) }
            })
                .frame(minWidth: leadingTrailingWidth, alignment: .leading)
                .layoutPriority(1)
                .readSize(onChange: { leadingWidth = $0.width })

            Spacer()

            HStack(spacing: model.layout.spacing, content: {
                Text(title)
                    .font(model.fonts.title)
            })

            Spacer()

            HStack(spacing: model.layout.spacing, content: {
                if let trailingItem = trailingItem { trailingItem }
            })
                .frame(minWidth: leadingTrailingWidth, alignment: .trailing)
                .layoutPriority(1)
                .readSize(onChange: { trailingWidth = $0.width })
        })
            .lineLimit(1)
            .frame(width: model.layout.width)
    }
}
