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
enum VBottomSheetHeaderLabel<Label>: Equatable where Label: View {
    // MARK: Cases
    case empty
    case title(title: String)
    case label(label: () -> Label)
    
    // MARK: Properties
    var hasLabel: Bool {
        switch self {
        case .empty: return false
        case .title: return true
        case .label: return true
        }
    }
    
    // MARK: Equatable
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.empty, .empty): return true
        case (.title(let lhs), .title(let rhs)): return lhs == rhs
        default: return false
        }
    }
}

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
                value: .label(label: { .init(label()) })
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
    
    static func reduce(
        value: inout VBottomSheetHeaderLabel<AnyView>,
        nextValue: () -> VBottomSheetHeaderLabel<AnyView>
    ) {
        value = nextValue()
    }
}
