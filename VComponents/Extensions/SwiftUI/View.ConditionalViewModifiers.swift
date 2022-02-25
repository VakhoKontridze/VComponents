//
//  ViewExtensions.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 18.12.20.
//

import SwiftUI

// MARK: - Conditional View Modifiers
extension View {
    /// Applies modifier and transforms view if condition is met.
    ///
    /// Usage Example:
    ///
    ///     let isRed: Bool = true
    ///
    ///     var body: some View {
    ///         Text("Lorem Ipsum")
    ///             .if(isRed, transform: { $0.foregroundColor(.red) })
    ///     }
    ///
    @ViewBuilder public func `if`<Content>(
        _ condition: Bool,
        transform: (Self) -> Content
    ) -> some View
        where Content: View
    {
        switch condition {
        case false: self
        case true: transform(self)
        }
    }

    /// Applies modifier and transforms view if condition is met, or applies alternate modifier.
    ///
    /// Usage Example:
    ///
    ///     let isError: Bool = true
    ///
    ///     var body: some View {
    ///         Text("Lorem Ipsum")
    ///             .if(
    ///                 isError,
    ///                 ifTransform: { $0.foregroundColor(.red) },
    ///                 elseTransform: { $0.fontWeight(.bold) }
    ///             )
    ///     }
    ///
    @ViewBuilder public func `if`<IfContent, ElseContent>(
        _ condition: Bool,
        ifTransform: (Self) -> IfContent,
        elseTransform: (Self) -> ElseContent
    ) -> some View
        where
            IfContent: View,
            ElseContent: View
    {
        switch condition {
        case false: elseTransform(self)
        case true: ifTransform(self)
        }
    }
    
    /// Applies modifier and transforms view if value is non-nil.
    ///
    /// Usage Example:
    ///
    ///     let color: Color? = .accentColor
    ///
    ///     var body: some View {
    ///         Text("Lorem Ipsum")
    ///             .ifLet(color, transform: { $0.foregroundColor($1) })
    ///     }
    ///
    @ViewBuilder public func ifLet<Value, Content>(
        _ value: Value?,
        transform: (Self, Value) -> Content
    ) -> some View
        where Content: View
    {
        switch value {
        case let value?: transform(self, value)
        case nil: self
        }
    }
    
    /// Applies modifier and transforms view if value is non-nil, or applies alternate modifier.
    ///
    /// Usage Example:
    ///
    ///     let color: Color? = .accentColor
    ///
    ///     var body: some View {
    ///         Text("Lorem Ipsum")
    ///             .ifLet(
    ///                 color,
    ///                 ifTransform: { $0.foregroundColor($1) },
    ///                 elseTransform: { $0.fontWeight(.bold) }
    ///             )
    ///     }
    ///
    @ViewBuilder public func `ifLet`<Value, IfContent, ElseContent>(
        _ value: Value?,
        ifTransform: (Self, Value) -> IfContent,
        elseTransform: (Self) -> ElseContent
    ) -> some View
        where
            IfContent: View,
            ElseContent: View
    {
        switch value {
        case let value?: ifTransform(self, value)
        case nil: elseTransform(self)
        }
    }
}
