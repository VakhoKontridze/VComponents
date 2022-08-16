//
//  VBottomSheetExtension.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 1/21/21.
//

import SwiftUI

// MARK: - Bool
extension View {
    /// Presents bottom sheet when `Bool` is `true`.
    ///
    /// Modal component that draws a background, and hosts pull-up content on the bottom of the screen.
    ///
    /// UI Model, and present and dismiss handlers can be passed as parameters.
    ///
    /// `vBottomSheet` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
    ///
    ///     @State var isPresented: Bool = false
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { isPresented = true },
    ///             title: "Present"
    ///         )
    ///             .vBottomSheet(
    ///                 id: "some_bottom_sheet",
    ///                 uiModel: .scrollableContentNoHeaderLabel,
    ///                 isPresented: $isPresented,
    ///                 content: {
    ///                     List(content: {
    ///                         ForEach(0..<20, content: { num in
    ///                             VListRow(separator: .noFirstAndLastSeparatorsInList(isFirst: num == 0), content: {
    ///                                 Text(String(num))
    ///                                     .frame(maxWidth: .infinity, alignment: .leading)
    ///                             })
    ///                         })
    ///                     })
    ///                         .vListStyle()
    ///                 }
    ///             )
    ///     }
    ///
    public func vBottomSheet(
        id: String,
        uiModel: VBottomSheetUIModel = .init(),
        isPresented: Binding<Bool>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> some View
    ) -> some View {
        self
            .onDisappear(perform: { PresentationHost.forceDismiss(id: id) })
            .background(PresentationHost(
                id: id,
                isPresented: isPresented,
                content: {
                    VBottomSheet<Never, _>(
                        uiModel: uiModel,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        headerLabel: .empty,
                        content: content
                    )
                }
            ))
    }
    
    /// Presents bottom sheet when `Bool` is `true`.
    ///
    /// Modal component that draws a background, and hosts pull-up content on the bottom of the screen.
    ///
    /// UI Model, and present and dismiss handlers can be passed as parameters.
    ///
    /// `vBottomSheet` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
    ///
    ///     @State var isPresented: Bool = false
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { isPresented = true },
    ///             title: "Present"
    ///         )
    ///             .vBottomSheet(
    ///                 id: "some_bottom_sheet",
    ///                 uiModel: .scrollableContent,
    ///                 isPresented: $isPresented,
    ///                 headerTitle: "Lorem Ipsum Dolor Sit Amet",
    ///                 content: {
    ///                     List(content: {
    ///                         ForEach(0..<20, content: { num in
    ///                             VListRow(separator: .noFirstAndLastSeparatorsInList(isFirst: num == 0), content: {
    ///                                 Text(String(num))
    ///                                     .frame(maxWidth: .infinity, alignment: .leading)
    ///                             })
    ///                         })
    ///                     })
    ///                         .vListStyle()
    ///                 }
    ///             )
    ///     }
    ///
    public func vBottomSheet(
        id: String,
        uiModel: VBottomSheetUIModel = .init(),
        isPresented: Binding<Bool>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        headerTitle: String,
        @ViewBuilder content: @escaping () -> some View
    ) -> some View {
        self
            .onDisappear(perform: { PresentationHost.forceDismiss(id: id) })
            .background(PresentationHost(
                id: id,
                isPresented: isPresented,
                content: {
                    VBottomSheet<Never, _>(
                        uiModel: uiModel,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        headerLabel: .title(title: headerTitle),
                        content: content
                    )
                }
            ))
    }
    
    /// Presents bottom sheet when `Bool` is `true`.
    ///
    /// Modal component that draws a background, and hosts pull-up content on the bottom of the screen.
    ///
    /// UI Model, and present and dismiss handlers can be passed as parameters.
    ///
    /// `vBottomSheet` modifier can be used on any view down the view hierarchy, as content overlay will always be overlayed on the screen.
    ///
    ///     @State var isPresented: Bool = false
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { isPresented = true },
    ///             title: "Present"
    ///         )
    ///             .vBottomSheet(
    ///                 id: "some_bottom_sheet",
    ///                 uiModel: .scrollableContent,
    ///                 isPresented: $isPresented,
    ///                 headerLabel: {
    ///                     HStack(content: {
    ///                         Image(systemName: "swift")
    ///                         Text("Lorem Ipsum Dolor Sit Amet").lineLimit(1)
    ///                     })
    ///                 },
    ///                 content: {
    ///                     List(content: {
    ///                         ForEach(0..<20, content: { num in
    ///                             VListRow(separator: .noFirstAndLastSeparatorsInList(isFirst: num == 0), content: {
    ///                                 Text(String(num))
    ///                                     .frame(maxWidth: .infinity, alignment: .leading)
    ///                             })
    ///                         })
    ///                     })
    ///                         .vListStyle()
    ///                 }
    ///             )
    ///     }
    ///
    public func vBottomSheet(
        id: String,
        uiModel: VBottomSheetUIModel = .init(),
        isPresented: Binding<Bool>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        @ViewBuilder headerLabel: @escaping () -> some View,
        @ViewBuilder content: @escaping () -> some View
    ) -> some View {
        self
            .onDisappear(perform: { PresentationHost.forceDismiss(id: id) })
            .background(PresentationHost(
                id: id,
                isPresented: isPresented,
                content: {
                    VBottomSheet(
                        uiModel: uiModel,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        headerLabel: .custom(label: headerLabel),
                        content: content
                    )
                }
            ))
    }
}

// MARK: - Item
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
    ///     @State var bottomSheetItem: BottomSheetItem?
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { bottomSheetItem = .init() },
    ///             title: "Present"
    ///         )
    ///             .vBottomSheet(
    ///                 id: "some_bottom_sheet",
    ///                 uiModel: .scrollableContentNoHeaderLabel,
    ///                 item: $bottomSheetItem,
    ///                 content: { item in
    ///                     List(content: {
    ///                         ForEach(0..<20, content: { num in
    ///                             VListRow(separator: .noFirstAndLastSeparatorsInList(isFirst: num == 0), content: {
    ///                                 Text(String(num))
    ///                                     .frame(maxWidth: .infinity, alignment: .leading)
    ///                             })
    ///                         })
    ///                     })
    ///                         .vListStyle()
    ///                 }
    ///             )
    ///     }
    ///
    public func vBottomSheet<Item>(
        id: String,
        uiModel: VBottomSheetUIModel = .init(),
        item: Binding<Item?>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (Item) -> some View
    ) -> some View
        where Item: Identifiable
    {
        item.wrappedValue.map { PresentationHostDataSourceCache.shared.set(key: id, value: $0) }

        return self
            .onDisappear(perform: { PresentationHost.forceDismiss(id: id) })
            .background(PresentationHost(
                id: id,
                isPresented: .init(
                    get: { item.wrappedValue != nil },
                    set: { if !$0 { item.wrappedValue = nil } }
                ),
                content: {
                    VBottomSheet<Never, _>(
                        uiModel: uiModel,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        headerLabel: .empty,
                        content: {
                            if let item = item.wrappedValue ?? PresentationHostDataSourceCache.shared.get(key: id) as? Item {
                                content(item)
                            }
                        }
                    )
                }
            ))
    }
    
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
    ///     @State var bottomSheetItem: BottomSheetItem?
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { bottomSheetItem = .init() },
    ///             title: "Present"
    ///         )
    ///             .vBottomSheet(
    ///                 id: "some_bottom_sheet",
    ///                 uiModel: .scrollableContent,
    ///                 item: $bottomSheetItem,
    ///                 headerTitle: { item in "Lorem Ipsum Dolor Sit Amet" },
    ///                 content: { item in
    ///                     List(content: {
    ///                         ForEach(0..<20, content: { num in
    ///                             VListRow(separator: .noFirstAndLastSeparatorsInList(isFirst: num == 0), content: {
    ///                                 Text(String(num))
    ///                                     .frame(maxWidth: .infinity, alignment: .leading)
    ///                             })
    ///                         })
    ///                     })
    ///                         .vListStyle()
    ///                 }
    ///             )
    ///     }
    ///
    public func vBottomSheet<Item>(
        id: String,
        uiModel: VBottomSheetUIModel = .init(),
        item: Binding<Item?>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        headerTitle: @escaping (Item) -> String,
        @ViewBuilder content: @escaping (Item) -> some View
    ) -> some View
        where Item: Identifiable
    {
        item.wrappedValue.map { PresentationHostDataSourceCache.shared.set(key: id, value: $0) }

        return self
            .onDisappear(perform: { PresentationHost.forceDismiss(id: id) })
            .background(PresentationHost(
                id: id,
                isPresented: .init(
                    get: { item.wrappedValue != nil },
                    set: { if !$0 { item.wrappedValue = nil } }
                ),
                content: {
                    VBottomSheet<Never, _>(
                        uiModel: uiModel,
                        onPresent: presentHandler,
                        onDismiss: dismissHandler,
                        headerLabel: {
                            if let item = item.wrappedValue ?? PresentationHostDataSourceCache.shared.get(key: id) as? Item {
                                return .title(title: headerTitle(item))
                            } else {
                                return .empty
                            }
                        }(),
                        content: {
                            if let item = item.wrappedValue ?? PresentationHostDataSourceCache.shared.get(key: id) as? Item {
                                content(item)
                            }
                        }
                    )
                }
            ))
    }
    
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
    ///     @State var bottomSheetItem: BottomSheetItem?
    ///
    ///     var body: some View {
    ///         VPlainButton(
    ///             action: { bottomSheetItem = .init() },
    ///             title: "Present"
    ///         )
    ///             .vBottomSheet(
    ///                 id: "some_bottom_sheet",
    ///                 uiModel: .scrollableContent,
    ///                 item: $bottomSheetItem,
    ///                 headerLabel: { item in
    ///                     HStack(content: {
    ///                         Image(systemName: "swift")
    ///                         Text("Lorem Ipsum Dolor Sit Amet").lineLimit(1)
    ///                     })
    ///                 },
    ///                 content: { item in
    ///                     List(content: {
    ///                         ForEach(0..<20, content: { num in
    ///                             VListRow(separator: .noFirstAndLastSeparatorsInList(isFirst: num == 0), content: {
    ///                                 Text(String(num))
    ///                                     .frame(maxWidth: .infinity, alignment: .leading)
    ///                             })
    ///                         })
    ///                     })
    ///                         .vListStyle()
    ///                 }
    ///             )
    ///     }
    ///
    public func vBottomSheet<Item>(
        id: String,
        uiModel: VBottomSheetUIModel = .init(),
        item: Binding<Item?>,
        onPresent presentHandler: (() -> Void)? = nil,
        onDismiss dismissHandler: (() -> Void)? = nil,
        @ViewBuilder headerLabel: @escaping (Item) -> some View,
        @ViewBuilder content: @escaping (Item) -> some View
    ) -> some View
        where Item: Identifiable
    {
        item.wrappedValue.map { PresentationHostDataSourceCache.shared.set(key: id, value: $0) }

        return self
            .onDisappear(perform: { PresentationHost.forceDismiss(id: id) })
            .background(PresentationHost(
                id: id,
                isPresented: .init(
                    get: { item.wrappedValue != nil },
                    set: { if !$0 { item.wrappedValue = nil } }
                ),
                content: {
                    VBottomSheet(
                       uiModel: uiModel,
                       onPresent: presentHandler,
                       onDismiss: dismissHandler,
                       headerLabel: {
                           if let item = item.wrappedValue ?? PresentationHostDataSourceCache.shared.get(key: id) as? Item {
                               return .custom(label: { headerLabel(item) })
                           } else {
                               return .empty
                           }
                       }(),
                       content: {
                           if let item = item.wrappedValue ?? PresentationHostDataSourceCache.shared.get(key: id) as? Item {
                               content(item)
                           }
                       }
                    )
                }
            ))
    }
}
