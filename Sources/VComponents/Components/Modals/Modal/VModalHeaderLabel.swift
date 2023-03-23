//
//  VModalHeaderLabel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 4/16/22.
//

import SwiftUI

// MARK: - V Modal Header Label
@available(iOS 15.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
typealias VModalHeaderLabel = GenericContent_EmptyTitleContent

// MARK: - V Modal Header Label Extension
@available(iOS 15.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {
    /// Configures `View`'s header title for purposes of presentation inside `VModal`.
    public func vModalHeaderTitle(_ title: String) -> some View {
        self
            .preference(
                key: VModalHeaderLabelPreferenceKey.self,
                value: .title(title: title)
            )
    }
    
    /// Configures `View`'s header label for purposes of presentation inside `VModal`.
    public func vModalHeaderLabel<Label>(
        @ViewBuilder _ label: @escaping () -> Label
    ) -> some View
        where Label: View
    {
        self
            .preference(
                key: VModalHeaderLabelPreferenceKey.self,
                value: .content(content: { .init(label()) })
            )
    }
}

// MARK: - V Modal Header Label Preference Key
@available(iOS 15.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct VModalHeaderLabelPreferenceKey: PreferenceKey {
    static var defaultValue: VModalHeaderLabel<AnyView> = .empty
    
    static func reduce(value: inout GenericContent_EmptyTitleContent<AnyView>, nextValue: () -> GenericContent_EmptyTitleContent<AnyView>) {
        value = nextValue()
    }
}
