//
//  VModalHeaderLabel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 4/16/22.
//

import SwiftUI

// MARK: - V Modal Header Label
typealias VModalHeaderLabel = GenericLabel_EmptyTitleCustom

// MARK: - V Modal Header Label Extension
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
                value: .custom(label: { .init(label()) })
            )
    }
}

// MARK: - V Modal Header Label Preference Key
struct VModalHeaderLabelPreferenceKey: PreferenceKey {
    static var defaultValue: VModalHeaderLabel<AnyView> = .empty
    
    static func reduce(value: inout GenericLabel_EmptyTitleCustom<AnyView>, nextValue: () -> GenericLabel_EmptyTitleCustom<AnyView>) {
        value = nextValue()
    }
}
