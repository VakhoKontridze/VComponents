//
//  VBottomSheetHeaderLabel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 4/18/22.
//

import SwiftUI

// MARK: - V Bottom Sheet Header Label
@available(iOS 15.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
typealias VBottomSheetHeaderLabel = GenericContent_EmptyTitleContent

// MARK: - V Bottom Sheet Header Label Extension
@available(iOS 15.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {
    /// Configures `View`'s header title for purposes of presentation inside `VBottomSheet`.
    public func vBottomSheetHeaderTitle(_ title: String) -> some View {
        self
            .preference(
                key: VBottomSheetHeaderLabelPreferenceKey.self,
                value: .title(title: title)
            )
    }
    
    /// Configures `View`'s header label for purposes of presentation inside `VBottomSheet`.
    public func vBottomSheetHeaderLabel<Label>(
        @ViewBuilder _ label: @escaping () -> Label
    ) -> some View
        where Label: View
    {
        self
            .preference(
                key: VBottomSheetHeaderLabelPreferenceKey.self,
                value: .content(content: { .init(label()) })
            )
    }
}

// MARK: - V Bottom Sheet Header Label Preference Key
@available(iOS 15.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct VBottomSheetHeaderLabelPreferenceKey: PreferenceKey {
    static var defaultValue: VBottomSheetHeaderLabel<AnyView> = .empty
    
    static func reduce(value: inout GenericContent_EmptyTitleContent<AnyView>, nextValue: () -> GenericContent_EmptyTitleContent<AnyView>) {
        value = nextValue()
    }
}
