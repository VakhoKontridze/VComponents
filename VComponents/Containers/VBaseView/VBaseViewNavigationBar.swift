//
//  VBaseViewNavigationBar.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI

// MARK:- Modifier
extension View {
    func setUpBaseViewNavigationBar<TrailingItemsContent: View>(
        model: VBaseViewModel,
        title: String,
        trailingItemsContent: (() -> TrailingItemsContent)?
    ) -> some View {
        modifier(VBaseViewNavigationBar(
            model: model,
            title: title,
            trailingItemsContent: trailingItemsContent
        ))
    }
}

// MARK:- V Base View Navigation Bar
struct VBaseViewNavigationBar<TrailingItemsContent>: ViewModifier where TrailingItemsContent: View {
    // MARK: Properties
    private let title: String
    private let model: VBaseViewModel
    
    private let trailingItemsContent: (() -> TrailingItemsContent)?
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    private var isDestination: Bool { presentationMode.wrappedValue.isPresented }
    
    // MARK: Initializers
    init(
        model: VBaseViewModel,
        title: String,
        trailingItemsContent: (() -> TrailingItemsContent)?
    ) {
        self.model = model
        self.title = title
        self.trailingItemsContent = trailingItemsContent
    }
}

// MARK:- Body
extension VBaseViewNavigationBar {
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .if(model.layout.titleAlignment == .center, transform: {
                $0.toolbar(content: { ToolbarItem(placement: .principal, content: { centerItems }) })
            })
            .navigationBarItems(
                leading: leadingItems,
                trailing: trailingItems
            )
    }
    
    private var leadingItems: some View {
        HStack(alignment: .center, spacing: model.layout.itemSpacing, content: {
            if isDestination {
                Button(action: back, label: {
                    Image(systemName: "arrow.left")
                })
            }

            if model.layout.titleAlignment == .leading {
                titleView
            }
        })
    }
    
    private var centerItems: some View {
        titleView
    }
    
    @ViewBuilder private var trailingItems: some View {
        if let trailingItemsContent = trailingItemsContent {
            trailingItemsContent()
        } else {
            EmptyView()
        }
    }

    private var titleView: some View {
        Text(title)
            .font(model.fonts.title)
    }
}

// MARK:- Back
private extension VBaseViewNavigationBar {
    func back() {
        presentationMode.wrappedValue.dismiss()
    }
}
