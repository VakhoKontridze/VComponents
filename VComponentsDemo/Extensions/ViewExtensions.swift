//
//  ViewExtensions.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- Conditional Modifiers
extension View {
    @ViewBuilder func `if`<Content>(
        _ condition: Bool, transform: (Self) -> Content
    ) -> some View
        where Content: View
    {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    @ViewBuilder func `if`<IfContent, ElseContent>(
        _ condition: Bool,
        ifTransform: (Self) -> IfContent,
        elseTransform: (Self) -> ElseContent
    ) -> some View
        where
            IfContent: View,
            ElseContent: View
    {
        if condition {
            ifTransform(self)
        } else {
            elseTransform(self)
        }
    }
    
    @ViewBuilder func ifLet<Content, Condition>(
        _ value: Condition?,
        transform: (Self, Condition) -> Content
    ) -> some View
        where Content: View
    {
        if let value = value {
            transform(self, value)
        } else {
            self
        }
    }
}

// MARK:- Frame
extension View {
    func frame(size: CGSize, alignment: Alignment = .center) -> some View {
        frame(
            width: size.width, height: size.height,
            alignment: alignment
        )
    }
    
    func frame(size: SizeConfiguration, alignment: Alignment = .center) -> some View {
        frame(
            minWidth: size.min.width, idealWidth: size.ideal.width, maxWidth: size.max.width,
            minHeight: size.min.height, idealHeight: size.ideal.height, maxHeight: size.max.height,
            alignment: alignment
        )
    }
}

struct SizeConfiguration {
    let min, ideal, max: CGSize
}
