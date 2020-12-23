//
//  ViewExtensions.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 18.12.20.
//

import Foundation
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
    func frame(dimension: CGFloat, alignment: Alignment = .center) -> some View {
        frame(
            width: dimension, height: dimension,
            alignment: alignment
        )
    }
    
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

// MARK:- Round Corners
extension View {
    func cornerRadius(radius: CGFloat, corners: UIRectCorner) -> some View {
        ModifiedContent(content: self, modifier: CornerRadiusStyle(radius: radius, corners: corners))
    }
}

struct CornerRadiusStyle: ViewModifier {
    var radius: CGFloat
    var corners: UIRectCorner

    struct CornerRadiusShape: Shape {
        var radius: CGFloat = .infinity
        var corners: UIRectCorner = .allCorners

        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            return Path(path.cgPath)
        }
    }

    func body(content: Content) -> some View {
        content
            .clipShape(CornerRadiusShape(radius: radius, corners: corners))
    }
}

// MARK:- Reading Size
extension View {
    func readSize(onChange completion: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader(content: { proxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: proxy.size)
            })
        )
            .onPreferenceChange(SizePreferenceKey.self, perform: completion)
    }
}

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
