//
//  View.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- Conditional Modifiers
extension View {
    @ViewBuilder func `if`<Transform: View>(
        _ condition: Bool, transform: (Self) -> Transform
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    @ViewBuilder func `if`<IfContent: View, ElseContent: View>(
        _ condition: Bool,
        ifTransform: (Self) -> IfContent,
        elseTransform: (Self) -> ElseContent
    ) -> some View {
        if condition {
            ifTransform(self)
        } else {
            elseTransform(self)
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
