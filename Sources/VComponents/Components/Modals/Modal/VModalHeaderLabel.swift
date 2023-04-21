//
//  VModalHeaderLabel.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 4/16/22.
//

import SwiftUI

// MARK: - V Modal Header Label
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
enum VModalHeaderLabel<Label>: Equatable where Label: View {
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

// MARK: - V Modal Header Label Extension
@available(iOS 14.0, *)
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
                value: .label(label: { AnyView(label()) })
            )
    }
}

// MARK: - V Modal Header Label Preference Key
@available(iOS 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct VModalHeaderLabelPreferenceKey: PreferenceKey {
    static var defaultValue: VModalHeaderLabel<AnyView> = .empty
    
    static func reduce(
        value: inout VModalHeaderLabel<AnyView>,
        nextValue: () -> VModalHeaderLabel<AnyView>
    ) {
        value = nextValue()
    }
}
