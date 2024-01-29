//
//  VBottomSheetExtension.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/21/21.
//

import SwiftUI
import VCore

// MARK: - Bool
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension View {
    /// Modal component hosts pull-up content on the bottom of the container.
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
    ///                 uiModel.autoresizesContent = true // For scrollable views
    ///                 return uiModel
    ///             }(),
    ///             isPresented: $isPresented,
    ///             content: {
    ///                 ScrollView(content: {
    ///                     VStack(spacing: 0, content: {
    ///                         ForEach(0..<20, content: { number in
    ///                             Text(String(number))
    ///                                 .frame(maxWidth: .infinity, alignment: .leading)
    ///                                 .padding(.horizontal, 15)
    ///                                 .padding(.vertical, 9)
    ///                         })
    ///                     })
    ///                     .safeAreaPadding(.bottom, UIDevice.safeAreaInsets.bottom)
    ///                 })
    ///             }
    ///         )
    ///     }
    ///
    /// Bottom sheet can also wrap it's content by reading geometry size.
    /// Although, the possibility of smaller screen sizes should be considered.
    ///
    ///     @State private var safeAreaInsets: EdgeInsets = .init()
    ///
    ///     @State private var isPresented: Bool = true
    ///     @State private var contentHeight: CGFloat?
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { isPresented = true },
    ///             title: "Present"
    ///         )
    ///         .getSafeAreaInsets({ safeAreaInsets = $0 })
    ///
    ///         .vBottomSheet(
    ///             id: "preview",
    ///             uiModel: {
    ///                 var uiModel: VBottomSheetUIModel = .init()
    ///
    ///                 uiModel.contentMargins = VBottomSheetUIModel.Margins(
    ///                     leading: 15,
    ///                     trailing: 15,
    ///                     top: 5,
    ///                     bottom: max(15, safeAreaInsets.bottom)
    ///                 )
    ///
    ///                 if let contentHeight {
    ///                     let height: CGFloat = uiModel.contentWrappingHeight(
    ///                         contentHeight: contentHeight,
    ///                         safeAreaInsets: safeAreaInsets
    ///                     )
    ///
    ///                     uiModel.sizes.portrait.heights = .absolutes(height)
    ///                     uiModel.sizes.portrait.heights = .absolutes(height)
    ///                 }
    ///
    ///                 return uiModel
    ///             }(),
    ///             isPresented: $isPresented,
    ///             content: {
    ///                 Text("...")
    ///                     .fixedSize(horizontal: false, vertical: true)
    ///                     .getSize({ size in
    ///                         DispatchQueue.main.async(execute: {
    ///                             contentHeight = size.height
    ///                         })
    ///                     })
    ///             }
    ///         )
    ///     }
    ///
    /// Bottom sheet can also wrap navigation system.
    ///
    ///     @State private var isPresented: Bool = false
    ///     @State private var modalDidAppear: Bool = false
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { isPresented = true },
    ///             title: "Present"
    ///         )
    ///         .vBottomSheet(
    ///             id: "test",
    ///             uiModel: {
    ///                 var uiModel: VBottomSheetUIModel = .noDragIndicator
    ///                 uiModel.sizes.portrait.heights = .fraction(0.6)
    ///                 return uiModel
    ///             }(),
    ///             isPresented: $isPresented,
    ///             onPresent: { modalDidAppear = true },
    ///             onDismiss: { modalDidAppear = false },
    ///             content: {
    ///                 NavigationStack(root: {
    ///                     HomeView(isPresented: $isPresented)
    ///                         // Disables possible `NavigationStack` animations
    ///                         .transaction({
    ///                             if !modalDidAppear { $0.animation = nil }
    ///                         })
    ///                 })
    ///                 // Resets `NavigationStack` frame that may prevent incorrect subview gesture regions
    ///                 .id(modalDidAppear)
    ///             }
    ///         )
    ///     }
    ///
    ///     struct HomeView: View {
    ///         @Binding private var isPresented: Bool
    ///
    ///         init(isPresented: Binding<Bool>) {
    ///             self._isPresented = isPresented
    ///         }
    ///
    ///         var body: some View {
    ///             NavigationLink(
    ///                 "To Destination",
    ///                 destination: { DestinationView(isPresented: $isPresented) }
    ///             )
    ///             .inlineNavigationTitle("Home")
    ///             .toolbar(content: {
    ///                 VPlainButton(
    ///                     action: { isPresented = false },
    ///                     title: "Dismiss"
    ///                 )
    ///             })
    ///         }
    ///     }
    ///
    ///     struct DestinationView: View {
    ///         @Environment(\.dismiss) private var dismissAction: DismissAction
    ///
    ///         @Binding private var isPresented: Bool
    ///
    ///         init(isPresented: Binding<Bool>) {
    ///             self._isPresented = isPresented
    ///         }
    ///
    ///         var body: some View {
    ///             VPlainButton(
    ///                 action: { dismissAction.callAsFunction() },
    ///                 title: "To Home"
    ///             )
    ///             .inlineNavigationTitle("Destination")
    ///             .toolbar(content: {
    ///                 VPlainButton(
    ///                     action: { isPresented = false },
    ///                     title: "Dismiss"
    ///                 )
    ///             })
    ///         }
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
                onPresent: presentHandler,
                onDismiss: dismissHandler,
                content: {
                    VBottomSheet<Content>(
                        uiModel: uiModel,
                        isPresented: isPresented,
                        content: content
                    )
                }
            )
    }
}

// MARK: - Item
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension View {
    /// Modal component hosts pull-up content on the bottom of the container.
    ///
    /// For additional info, refer to `View.vBottomSheet(id:isPresented:content:)`.
    public func vBottomSheet<Item, Content>(
        id: String,
        uiModel: VBottomSheetUIModel = .init(),
        item: Binding<Item?>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (Item) -> Content
    ) -> some View
        where Content: View
    {
        item.wrappedValue.map { PresentationHostDataSourceCache.shared.set(key: id, value: $0) }

        let isPresented: Binding<Bool> = .init(
            get: { item.wrappedValue != nil },
            set: { if !$0 { item.wrappedValue = nil } }
        )

        return self
            .presentationHost(
                id: id,
                uiModel: uiModel.presentationHostUIModel,
                isPresented: isPresented,
                onPresent: presentHandler,
                onDismiss: dismissHandler,
                content: {
                    VBottomSheet<Content?>(
                        uiModel: uiModel,
                        isPresented: isPresented,
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
