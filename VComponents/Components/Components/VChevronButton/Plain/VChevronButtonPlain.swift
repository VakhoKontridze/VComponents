//
//  VChevronButtonPlain.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/23/20.
//

import SwiftUI

// MARK:- V Chevron Button Plain
struct VChevronButtonPlain<Content>: View where Content: View {
    // MARK: Properties
    private let model: VChevronButtonPlainModel
    
    private let direction: VChevronButtonDirection
    private let state: VChevronButtonState
    
    private let action: () -> Void
    
    private let content: () -> Content
    
    // MARK: Direction
    public init(
        model: VChevronButtonPlainModel,
        direction: VChevronButtonDirection,
        state: VChevronButtonState,
        action: @escaping () -> Void,
        content: @escaping () -> Content
    ) {
        self.model = model
        self.direction = direction
        self.state = state
        self.action = action
        self.content = content
    }
}

// MARK:- Body
extension VChevronButtonPlain {
    var body: some View {
        VCircularButton(.filled(model.circularButtonModel), state: state, action: action, content: {
            content()
                .frame(dimension: model.layout.iconDimension)
                .frame(dimension: model.layout.iconDimension)
                .padding(.horizontal, model.layout.hitBoxSpacingX)
                .padding(.vertical, model.layout.hitBoxSpacingY)
        })
    }
}

// MARK:- Preview
struct VChevronButtonPlain_Previews: PreviewProvider {
    static var previews: some View {
        VChevronButtonFilled(model: .init(), direction: .left, state: .enabled, action: {}, content: {
            Image(systemName: "chevron.up")
                .rotationEffect(.init(degrees: -90))
        })
    }
}
