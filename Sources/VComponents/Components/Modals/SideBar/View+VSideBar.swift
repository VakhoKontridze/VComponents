//
//  View+VSideBar.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI
import VCore

// MARK: - View + V Side Bar - Bool
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension View {
    /// Presents side bar when boolean is `true`.
    ///
    /// Side bar component that draws from an edge with background, and hosts content.
    ///
    ///     @State private var isPresented: Bool = false
    ///
    ///     var body: some View {
    ///         ZStack(content: {
    ///             VPlainButton(
    ///                 action: { isPresented = true },
    ///                 title: "Present"
    ///             )
    ///             .vSideBar(
    ///                 id: "some_side_bar",
    ///                 isPresented: $isPresented,
    ///                 content: { Color.blue }
    ///             )
    ///         })
    ///         .frame(maxWidth: .infinity, maxHeight: .infinity)
    ///         .presentationHostLayer() // Or declare in `App` on a `WindowScene`-level
    ///     }
    ///
    /// Due to a Presentation Host API, side bar loses its intrinsic safe area properties, and requires custom handling and implementation.
    /// UI model contains `contentSafeAreaEdges`, that inserts `Spacer` with the dimension of safe area on specified edges.
    /// However, these insets are presents even if side bar content doesn't need them.
    /// Therefore, a custom implementation is needed per use-case.
    /// By default, `defaultContentSafeAreaEdges(interfaceOrientation:)` method is provided that serves that purpose.
    ///
    ///     @State private var isPresented: Bool = false
    ///     @State private var interfaceOrientation: UIInterfaceOrientation = .unknown
    ///
    ///     var body: some View {
    ///         ZStack(content: {
    ///             VPlainButton(
    ///                 action: { isPresented = true },
    ///                 title: "Present"
    ///             )
    ///             .getInterfaceOrientation({ interfaceOrientation = $0 })
    ///             .vSideBar(
    ///                 id: "some_side_bar",
    ///                 uiModel: {
    ///                     var uiModel: VSideBarUIModel = .leading
    ///
    ///                     uiModel.contentSafeAreaEdges = uiModel.defaultContentSafeAreaEdges(interfaceOrientation: interfaceOrientation)
    ///
    ///                     return uiModel
    ///                 }(),
    ///                 isPresented: $isPresented,
    ///                 content: { Color.blue }
    ///             )
    ///         })
    ///         .frame(maxWidth: .infinity, maxHeight: .infinity)
    ///         .presentationHostLayer() // Or declare in `App` on a `WindowScene`-level
    ///     }
    ///
    public func vSideBar<Content>(
        layerID: String? = nil,
        id: String,
        uiModel: VSideBarUIModel = .init(),
        isPresented: Binding<Bool>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View
        where Content: View
    {
        self
            .presentationHost(
                layerID: layerID,
                id: id,
                uiModel: uiModel.presentationHostSubUIModel,
                isPresented: isPresented,
                onPresent: presentHandler,
                onDismiss: dismissHandler,
                content: {
                    VSideBar<Content>(
                        uiModel: uiModel,
                        isPresented: isPresented,
                        content: content
                    )
                }
            )
    }
}

// MARK: - View + V Side Bar - Item
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension View {
    /// Presents side bar using the item as data source for content.
    ///
    /// For additional info, refer to method with `Bool` presentation flag.
    public func vSideBar<Item, Content>(
        layerID: String? = nil,
        id: String,
        uiModel: VSideBarUIModel = .init(),
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
                layerID: layerID,
                id: id,
                uiModel: uiModel.presentationHostSubUIModel,
                isPresented: isPresented,
                onPresent: presentHandler,
                onDismiss: dismissHandler,
                content: {
                    VSideBar<Content?>(
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
