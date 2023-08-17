//
//  VSideBarExtension.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI
import VCore

// MARK: - Bool
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {
    /// Presents side bar when boolean is `true`.
    ///
    /// Side bar component that draws a from edge with background, and hosts content.
    ///
    /// UI Model, and present and dismiss handlers can be passed as parameters.
    ///
    ///     @State private var isPresented: Bool = false
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { isPresented = true },
    ///             title: "Present"
    ///         )
    ///         .vSideBar(
    ///             id: "some_side_bar",
    ///             isPresented: $isPresented,
    ///             content: {
    ///                 ColorBook.accentBlue
    ///             }
    ///         )
    ///     }
    ///
    public func vSideBar<Content>(
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
                id: id,
                uiModel: uiModel.presentationHostUIModel,
                isPresented: isPresented,
                content: {
                    VSideBar<Content>(
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
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {
    /// Presents side bar using the item as data source for content.
    ///
    /// Side bar component that draws a from edge with background, and hosts content.
    ///
    /// UI Model, and present and dismiss handlers can be passed as parameters.
    ///
    ///     struct SideBarItem: Identifiable {
    ///         let id: UUID = .init()
    ///     }
    ///
    ///     @State private var sideBarItem: SideBarItem?
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { sideBarItem = SideBarItem() },
    ///             title: "Present"
    ///         )
    ///         .vSideBar(
    ///             id: "some_side_bar",
    ///             item: $sideBarItem,
    ///             content: {
    ///                 ColorBook.accentBlue
    ///             }
    ///         )
    ///     }
    ///
    public func vSideBar<Item, Content>(
        id: String,
        uiModel: VSideBarUIModel = .init(),
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
                    VSideBar<Content?>(
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
