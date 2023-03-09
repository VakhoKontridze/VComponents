//
//  VBottomSheetHeaderLabel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 4/18/22.
//

import SwiftUI

// MARK: - V Bottom Sheet Header Label
@available(iOS 15.0, *)
typealias VBottomSheetHeaderLabel = GenericLabel_EmptyTitleCustom

// MARK: - V Bottom Sheet Header Label Extension
@available(iOS 15.0, *)
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
                value: .custom(label: { .init(label()) })
            )
    }
}

// MARK: - V Bottom Sheet Header Label Preference Key
@available(iOS 15.0, *)
struct VBottomSheetHeaderLabelPreferenceKey: PreferenceKey {
    static var defaultValue: VBottomSheetHeaderLabel<AnyView> = .empty
    
    static func reduce(value: inout GenericLabel_EmptyTitleCustom<AnyView>, nextValue: () -> GenericLabel_EmptyTitleCustom<AnyView>) {
        value = nextValue()
    }
}
