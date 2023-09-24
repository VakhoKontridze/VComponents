//
//  VSideBarExtension.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/24/20.
//

import SwiftUI
import VCore

// MARK: - Bool
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {
    /// Presents side bar when boolean is `true`.
    ///
    /// Side bar component that draws from an edge with background, and hosts content.
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
    ///             content: { VComponentsColorBook.accentBlue }
    ///         )
    ///     }
    ///
    /// Due to a Presentation Host API, side bar loses its intrinsic safe area properties, and requires custom handling and implementation.
    /// UI model contains `contentSafeAreaMargins`, that inserts `Spacer` with the dimension of safe area on specified edges.
    /// However, these insets are presents even if side bar content doesn't need them.
    /// Therefore, a custom implementation is needed per use-case.
    /// For `leading`-presented side bars, safe area can be flipped between `leading` and `vertical` edges based on interface orientation.
    ///
    ///     @State private var isPresented: Bool = false
    ///     @State private var interfaceOrientation: UIInterfaceOrientation = .unknown
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { isPresented = true },
    ///             title: "Present"
    ///         )
    ///         .getInterfaceOrientation({ interfaceOrientation = $0 })
    ///         .vSideBar(
    ///             id: "some_side_bar",
    ///             uiModel: {
    ///                 var uiModel: VSideBarUIModel = .leading
    ///
    ///                 uiModel.contentSafeAreaMargins = {
    ///                     if interfaceOrientation.isLandscape {
    ///                         .leading
    ///                     } else {
    ///                         .vertical
    ///                     }
    ///                 }()
    ///
    ///                 return uiModel
    ///             }(),
    ///             isPresented: $isPresented,
    ///             content: { VComponentsColorBook.accentBlue }
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
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {
    /// Presents side bar using the item as data source for content.
    ///
    /// For additional info, refer to `View.vSideBar(id:isPresented:content:)`.
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
