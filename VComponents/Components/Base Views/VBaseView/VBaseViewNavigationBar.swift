//
//  VBaseViewNavigationBar.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI

// MARK:- Modifier
extension View {
    func setUpBaseViewNavigationBar<LeadingItem, TrailingItem>(
        model: VBaseViewModel,
        title: String,
        leadingItem: LeadingItem?,
        trailingItem: TrailingItem?
    ) -> some View
        where
            LeadingItem: View,
            TrailingItem: View
    {
        modifier(VBaseViewNavigationBar(
            model: model,
            title: title,
            leadingItem: leadingItem,
            trailingItem: trailingItem
        ))
    }
}

// MARK:- V Base View Navigation Bar
struct VBaseViewNavigationBar<TrailingItem, LeadingItem>: ViewModifier
    where
        LeadingItem: View,
        TrailingItem: View
{
    // MARK: Properties
    private let title: String
    private let model: VBaseViewModel
    
    private let leadingItem: LeadingItem?
    private let trailingItem: TrailingItem?
    
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
        model: VBaseViewModel,
        title: String,
        leadingItem: LeadingItem?,
        trailingItem: TrailingItem?
    ) {
        self.model = model
        self.title = title
        self.leadingItem = leadingItem
        self.trailingItem = trailingItem
    }
}

// MARK:- Body
extension VBaseViewNavigationBar {
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar(content: { ToolbarItem(placement: .navigationBarLeading, content: { items }) })
    }

    private var items: some View {
        Group(content: {
            switch model.layout.titleAlignment {
            case .leading:
                HStack(spacing: model.layout.spacing, content: {
                    if let leadingItem = leadingItem { leadingItem.layoutPriority(1) }
                    
                    if isDestination { VChevronButton(direction: .left, action: back).layoutPriority(1) }
                    
                    Text(title)
                        .layoutPriority(0)
                        .font(model.fonts.title)
                    
                    Spacer()
                    
                    if let trailingItem = trailingItem { trailingItem.layoutPriority(1) }
                })
                
            case .center:
                HStack(spacing: model.layout.spacing, content: {
                    HStack(spacing: model.layout.spacing, content: {
                        if let leadingItem = leadingItem { leadingItem }
                        
                        if isDestination { VChevronButton(direction: .left, action: back) }
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
            }
        })
            .lineLimit(1)
            .frame(width: model.layout.width)
    }
}

// MARK:- Back
private extension VBaseViewNavigationBar {
    func back() {
        presentationMode.wrappedValue.dismiss()
    }
}
