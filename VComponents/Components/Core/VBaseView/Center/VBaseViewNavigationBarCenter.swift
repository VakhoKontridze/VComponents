//
//  VBaseViewNavigationBarCenter.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI

// MARK:- Modifier
extension View {
    func setUpBaseViewNavigationBarCenter<LeadingItem, TrailingItem>(
        model: VBaseViewModelCenter,
        title: String,
        leadingItem: LeadingItem?,
        trailingItem: TrailingItem?,
        onBack backAction: @escaping () -> Void
    ) -> some View
        where
            LeadingItem: View,
            TrailingItem: View
    {
        modifier(VBaseViewNavigationBarCenter(
            model: model,
            title: title,
            leadingItem: leadingItem,
            trailingItem: trailingItem,
            onBack: backAction
        ))
    }
}

// MARK:- V Base View Navigation Bar Center
struct VBaseViewNavigationBarCenter<TrailingItem, LeadingItem>: ViewModifier
    where
        LeadingItem: View,
        TrailingItem: View
{
    // MARK: Properties
    private let title: String
    private let model: VBaseViewModelCenter
    
    private let leadingItem: LeadingItem?
    private let trailingItem: TrailingItem?
    
    private let backAction: () -> Void
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @State private var wasMainPresentation: Bool = false    // Envriornment var returns false after futher navigation
    private var isDestination: Bool {
        let state: Bool = presentationMode.wrappedValue.isPresented
        let actualState: Bool = wasMainPresentation || state
        DispatchQueue.main.async(execute: { if !wasMainPresentation { wasMainPresentation = state } })
        return actualState
    }
    
    @State private var leadingWidth: CGFloat = .zero
    @State private var trailingWidth: CGFloat = .zero
    private var leadingTrailingWidth: CGFloat? {
        let max: CGFloat? = [leadingWidth, trailingWidth].max()
        return max != .zero ? max : nil
    }
    
    // MARK: Initializers
    init(
        model: VBaseViewModelCenter,
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
extension VBaseViewNavigationBarCenter {
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
                    .font(model.font)
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
