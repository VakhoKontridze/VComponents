//
//  VBottomSheetExtension.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/21/21.
//

import SwiftUI
import VCore

// MARK: - Bool
@available(iOS 14.0, *)
@available(macOS 11.0, *)@available(macOS, unavailable)
@available(tvOS 14.0, *)@available(tvOS, unavailable)
@available(watchOS 7.0, *)@available(watchOS, unavailable)
extension View {
    /// Presents bottom sheet when `Bool` is `true`.
    ///
    /// Modal component that draws a background, and hosts pull-up content on the bottom of the screen.
    ///
    /// UI Model, and present and dismiss handlers can be passed as parameters.
    ///
    /// `vBottomSheet` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
    ///
    ///     @State private var isPresented: Bool = false
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { isPresented = true },
    ///             title: "Present"
    ///         )
    ///         .vBottomSheet(
    ///             id: "some_bottom_sheet",
    ///             uiModel: {
    ///                 var uiModel: VBottomSheetUIModel = .init()
    ///                 uiModel.autoresizesContent = true
    ///                 return uiModel
    ///             }(),
    ///             isPresented: $isPresented,
    ///             content: {
    ///                 ScrollView(content: {
    ///                     VStack(spacing: 0, content: {
    ///                         ForEach(0..<20, content: { number in
    ///                             VListRow(uiModel: .noFirstAndLastSeparators(isFirst: number == 0), content: {
    ///                                 Text(String(number))
    ///                                     .frame(maxWidth: .infinity, alignment: .leading)
    ///                             })
    ///                         })
    ///
    ///                         Spacer().frame(height: UIDevice.safeAreaInsets.bottom)
    ///                     })
    ///                 })
    ///             }
    ///         )
    ///     }
    ///
    public func vBottomSheet<Content>(
        id: String,
        uiModel: VBottomSheetUIModel = .init(),
        isPresented: Binding<Bool>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View
        where Content: View
    {
        self
            .presentationHost(
                id: id,
                uiModel: uiModel.presentationHostUIModel,
                isPresented: isPresented,
                content: {
                    VBottomSheet<Content>(
                        uiModel: uiModel,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        content: content
                    )
                }
            )
    }
}

// MARK: - Item
@available(iOS 14.0, *)
@available(macOS 11.0, *)@available(macOS, unavailable)
@available(tvOS 14.0, *)@available(tvOS, unavailable)
@available(watchOS 7.0, *)@available(watchOS, unavailable)
extension View {
    /// Presents bottom sheet when `Bool` is `true`.
    ///
    /// Modal component that draws a background, and hosts pull-up content on the bottom of the screen.
    ///
    /// UI Model, and present and dismiss handlers can be passed as parameters.
    ///
    /// `vBottomSheet` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
    ///
    ///     struct BottomSheetItem: Identifiable {
    ///         let id: UUID = .init()
    ///     }
    ///
    ///     @State private var bottomSheetItem: BottomSheetItem?
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { bottomSheetItem = BottomSheetItem() },
    ///             title: "Present"
    ///         )
    ///         .vBottomSheet(
    ///             id: "some_bottom_sheet",
    ///             uiModel: {
    ///                 var uiModel: VBottomSheetUIModel = .init()
    ///                 uiModel.autoresizesContent = true
    ///                 return uiModel
    ///             }(),
    ///             item: $bottomSheetItem,
    ///             content: { item in
    ///                 ScrollView(content: {
    ///                     VStack(spacing: 0, content: {
    ///                         ForEach(0..<20, content: { number in
    ///                             VListRow(uiModel: .noFirstAndLastSeparators(isFirst: number == 0), content: {
    ///                                 Text(String(number))
    ///                                     .frame(maxWidth: .infinity, alignment: .leading)
    ///                             })
    ///                         })
    ///
    ///                         Spacer().frame(height: UIDevice.safeAreaInsets.bottom)
    ///                     })
    ///                 })
    ///             }
    ///         )
    ///     }
    ///
    public func vBottomSheet<Item, Content>(
        id: String,
        uiModel: VBottomSheetUIModel = .init(),
        item: Binding<Item?>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (Item) -> Content
    ) -> some View
        where
            Item: Identifiable,
            Content: View
    {
        item.wrappedValue.map { PresentationHostDataSourceCache.shared.set(key: id, value: $0) }
        
        return self
            .presentationHost(
                id: id,
                uiModel: uiModel.presentationHostUIModel,
                item: item,
                content: {
                    VBottomSheet<Content?>(
                        uiModel: uiModel,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        content: {
                            if let item = item.wrappedValue ?? PresentationHostDataSourceCache.shared.get(key: id) as? Item {
                                content(item)
                            }
                        }
                    )
                }
            )
    }
}
