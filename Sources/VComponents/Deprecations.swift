//
//  Deprecations.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 2/12/21.
//

import SwiftUI
import VCore

// MARK: - V Side Bar
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VSideBarUIModel {
    @available(*, deprecated, renamed: "contentSafeAreaEdges")
    public var contentSafeAreaMargins: Edge.Set {
        get { contentSafeAreaEdges }
        set { contentSafeAreaEdges = newValue }
    }
}

// MARK: - V Bottom Sheet
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension VBottomSheetUIModel {
    @available(*, deprecated, renamed: "contentSafeAreaEdges")
    public var contentSafeAreaMargins: Edge.Set {
        get { contentSafeAreaEdges }
        set { contentSafeAreaEdges = newValue }
    }
}

// MARK: - V Menu
@available(*, unavailable)
public struct VMenu {}

@available(*, unavailable)
public struct VMenuRow {}

@available(*, unavailable)
public struct VMenuExpandingRow {}

@available(*, unavailable)
public struct VMenuPickerRow {}

@available(*, unavailable)
@resultBuilder public struct VMenuGroupRowBuilder {
    public static func buildBlock() -> [any VMenuGroupRowProtocol] {
        []
    }
}

@available(*, unavailable)
public protocol VMenuGroupRowConvertible {}

@available(*, unavailable)
public protocol VMenuPickerRowConvertible {}

@available(*, unavailable)
public protocol VMenuGroupRowProtocol {}

@available(*, unavailable)
public protocol VMenuPickerRowProtocol {}

@available(*, unavailable)
public struct VMenuGroupSection {}

@available(*, unavailable)
public struct VMenuPickerSection {}

@available(*, unavailable)
@resultBuilder public struct VMenuSectionBuilder {
    public static func buildBlock() -> [any VMenuSectionProtocol] {
        []
    }
}

@available(*, unavailable)
public protocol VMenuSectionConvertible {}

@available(*, unavailable)
public protocol VMenuSectionProtocol {}

@available(*, unavailable)
public struct VMenuInternalState {}

@available(*, unavailable)
public struct VMenuUIModel {}

// MARK: - V Context Menu
extension View {
    @available(*, unavailable)
    public func vContextMenu(
        @VMenuSectionBuilder sections: @escaping () -> [any VMenuSectionProtocol]
    ) -> some View {
        Color.clear
    }

    @available(*, unavailable)
    public func vContextMenu<PreviewContent>(
        @VMenuSectionBuilder sections: @escaping () -> [any VMenuSectionProtocol],
        preview: () -> PreviewContent
    ) -> some View
        where PreviewContent: View
    {
        Color.clear
    }
}
