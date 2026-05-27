//
//  GenericStateAndModel_EnabledFocusedDisabled_EmptyFilled.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 8/5/26.
//

public import SwiftUI
#if canImport(UIKit)
public import UIKit
#elseif canImport(AppKit)
public import AppKit
#endif
import VCore

/// Enumeration that represents state.
nonisolated public enum GenericState_EnabledFocusedDisabled_EmptyFilled: Int, Sendable, CaseIterable {
    // MARK: Cases
    /// Enabled.
    case enabledEmpty
    
    /// Enabled (filled).
    case enabledFilled
    
    /// Focused.
    case focusedEmpty
    
    /// Focused (filled).
    case focusedFilled
    
    /// Disabled.
    case disabled
    
    // MARK: Initializers
    /// Initializes `GenericState_EnabledFocusedDisabled_EmptyFilled` with flags.
    public init(
        isEnabled: Bool,
        isFocused: Bool,
        isFilled: Bool
    ) {
        switch (isEnabled, isFocused, isFilled) {
        case (false, _, _): self = .disabled
        case (true, false, false): self = .enabledEmpty
        case (true, false, true): self = .enabledFilled
        case (true, true, false): self = .focusedEmpty
        case (true, true, true): self = .focusedFilled
        }
    }
}

/// Model containing generic state-bound values.
@MemberwiseInitializable(
    comment: "/// Initializes `GenericStateModel_EnabledFocusedDisabled_EmptyFilled` with values."
)
nonisolated public struct GenericStateModel_EnabledFocusedDisabled_EmptyFilled<Value> {
    // MARK: Properties
    /// Enabled value.
    public var enabledEmpty: Value
    
    /// Enabled (filled) value.
    public var enabledFilled: Value
    
    /// Focused value.
    public var focusedEmpty: Value
    
    /// Focused (filled) value.
    public var focusedFilled: Value
    
    /// Disabled value.
    public var disabled: Value
    
    // MARK: Initializers
    /// Initializes `GenericStateModel_EnabledFocusedDisabled_EmptyFilled` with value.
    public init(
        _ value: Value
    ) {
        self.enabledEmpty = value
        self.enabledFilled = value
        self.focusedEmpty = value
        self.focusedFilled = value
        self.disabled = value
    }
    
    // MARK: Initializers - Dimensions
    /// Initializes `GenericStateModel_EnabledFocusedDisabled_EmptyFilled` with `0` `CGFloat` values.
    public static var zero: GenericStateModel_EnabledFocusedDisabled_EmptyFilled<CGFloat> {
        .init(0)
    }
    
    // MARK: Initializers - Colors
    /// Initializes `GenericStateModel_EnabledFocusedDisabled_EmptyFilled` with `clear` `Color` values.
    public static var clearColors: GenericStateModel_EnabledFocusedDisabled_EmptyFilled<Color> {
        .init(.clear)
    }

#if canImport(UIKit)
    
    /// Initializes `GenericStateModel_EnabledFocusedDisabled_EmptyFilled` with `clear` `UIColor` values.
    public static var clearUIColors: GenericStateModel_EnabledFocusedDisabled_EmptyFilled<UIColor> {
        .init(.clear)
    }
    
#elseif canImport(AppKit)
    
    /// Initializes `GenericStateModel_EnabledFocusedDisabled_EmptyFilled` with `clear` `NSColor` values.
    public static var clearNSColors: GenericStateModel_EnabledFocusedDisabled_EmptyFilled<NSColor> {
        .init(.clear)
    }
    
#endif

    // MARK: Map
    /// Returns `GenericStateModel_EnabledFocusedDisabled_EmptyFilled`  containing the results of mapping the given closure over the values.
    public func map<NewValue>(
        _ transform: (Value) throws -> NewValue
    ) rethrows -> GenericStateModel_EnabledFocusedDisabled_EmptyFilled<NewValue> {
        .init(
            enabledEmpty: try transform(enabledEmpty),
            enabledFilled: try transform(enabledFilled),
            focusedEmpty: try transform(focusedEmpty),
            focusedFilled: try transform(focusedFilled),
            disabled: try transform(disabled)
        )
    }
}

nonisolated extension GenericStateModel_EnabledFocusedDisabled_EmptyFilled: Equatable where Value: Equatable {}

nonisolated extension GenericStateModel_EnabledFocusedDisabled_EmptyFilled: Hashable where Value: Hashable {}

nonisolated extension GenericStateModel_EnabledFocusedDisabled_EmptyFilled: Sendable where Value: Sendable {}

nonisolated extension GenericStateModel_EnabledFocusedDisabled_EmptyFilled {
    /// Maps state to model.
    public func value(for state: GenericState_EnabledFocusedDisabled_EmptyFilled) -> Value {
        switch state {
        case .enabledEmpty: enabledEmpty
        case .enabledFilled: enabledFilled
        case .focusedEmpty: focusedEmpty
        case .focusedFilled: focusedFilled
        case .disabled: disabled
        }
    }
}
