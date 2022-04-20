//
//  VBottomSheet.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/21/21.
//

import SwiftUI

// MARK: - V Bottom Sheet
/// Modal component that draws a background, hosts pull-up content on the bottom of the screen, and is present when condition is true.
///
/// Model and header can be passed as parameters.
///
/// If invalid height parameters are passed during `init`, layout would invalidate itself, and refuse to draw.
///
/// `vBottomSheet` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
///
/// Usage example:
///
///     @State var isPresented: Bool = false
///
///     var body: some View {
///         VPlainButton(
///             action: { isPresented = true },
///             title: "Present"
///         )
///             .vBottomSheet(isPresented: $isPresented, bottomSheet: {
///                 VBottomSheet(
///                     headerTitle: "Lorem ipsum dolor sit amet",
///                     content: {
///                         ColorBook.accent
///                             .padding(.bottom, 10)
///                     }
///                 )
///             })
///     }
///
/// BottomSheet also support srollable content:
///
///     @State var isPresented: Bool = false
///
///     var body: some View {
///         VPlainButton(
///             action: { isPresented = true },
///             title: "Present"
///         )
///             .vBottomSheet(isPresented: $isPresented, bottomSheet: {
///                 VBottomSheet(
///                     model: {
///                         var model: VBottomSheetModel = .init()
///                         model.layout.autoresizesContent = true
///                         model.layout.hasSafeAreaMarginBottom = true
///                         return model
///                     }(),
///                     headerTitle: "Lorem ipsum dolor sit amet",
///                     content: {
///                         VList(data: 0..<20, rowContent: { num in
///                             Text(String(num))
///                                 .frame(maxWidth: .infinity, alignment: .leading)
///                         })
///                     }
///                 )
///             })
///     }
///
public struct VBottomSheet<HeaderLabel, Content>
    where
        HeaderLabel: View,
        Content: View
{
    // MARK: Properties
    fileprivate let model: VBottomSheetModel
    
    fileprivate let headerLabel: VBottomSheetHeaderLabel<HeaderLabel>
    fileprivate let content: () -> Content
    
    // MARK: Initializers
    /// Initializes component content.
    public init(
        model: VBottomSheetModel = .init(),
        @ViewBuilder content: @escaping () -> Content
    )
        where HeaderLabel == Never
    {
        self.model = model
        self.headerLabel = .empty
        self.content = content
    }
    
    /// Initializes component with header title and content.
    public init(
        model: VBottomSheetModel = .init(),
        headerTitle: String,
        @ViewBuilder content: @escaping () -> Content
    )
        where HeaderLabel == Never
    {
        self.model = model
        self.headerLabel = .title(title: headerTitle)
        self.content = content
    }
    
    /// Initializes component with header and content.
    public init(
        model: VBottomSheetModel = .init(),
        @ViewBuilder headerLabel: @escaping () -> HeaderLabel,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.model = model
        self.headerLabel = .custom(label: headerLabel)
        self.content = content
    }
}

// MARK: - Extension
extension View {
    /// Presents `VBottomSheet` when boolean is true.
    public func vBottomSheet<HeaderLabel, Content>(
        isPresented: Binding<Bool>,
        onDismiss dismissHandler: (() -> Void)? = nil,
        bottomSheet: @escaping () -> VBottomSheet<HeaderLabel, Content>
    ) -> some View
        where
            HeaderLabel: View,
            Content: View
    {
        let bottomSheet = bottomSheet()
        
        return self
            .background(PresentationHost(
                isPresented: isPresented,
                content: {
                    _VBottomSheet(
                        model: bottomSheet.model,
                        onDismiss: dismissHandler,
                        headerLabel: bottomSheet.headerLabel,
                        content: bottomSheet.content
                    )
                }
            ))
    }
    
    /// Presents `VBottomSheet` using the item as data source for content.
    @ViewBuilder public func vBottomSheet<Item, HeaderLabel, Content>(
        item: Binding<Item?>,
        onDismiss dismissHandler: (() -> Void)? = nil,
        bottomSheet: @escaping (Item) -> VBottomSheet<HeaderLabel, Content>
    ) -> some View
        where
            Item: Identifiable,
            HeaderLabel: View,
            Content: View
    {
        switch item.wrappedValue {
        case nil:
            self
            
        case let _item?:
            self
                .vBottomSheet(
                    isPresented: .init(
                        get: { true },
                        set: { _ in item.wrappedValue = nil }
                    ),
                    onDismiss: dismissHandler,
                    bottomSheet: { bottomSheet(_item) }
                )
        }
    }
}
