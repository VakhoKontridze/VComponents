//
//  VChevronButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI

// MARK:- V Chevron Button
public struct VChevronButton<Content>: View where Content: View {
    // MARK: Properties
    private let model: VChevronButtonModel
    
    private let direction: VChevronButtonDirection
    private let state: VChevronButtonState
    
    private let action: () -> Void
    
    private let content: (() -> Content)?
    
    // MARK: Direction
    public init(
        model: VChevronButtonModel = .init(),
        direction: VChevronButtonDirection,
        state: VChevronButtonState = .enabled,
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

public extension VChevronButton where Content == Never {
    init(
        model: VChevronButtonModel = .init(),
        direction: VChevronButtonDirection,
        state: VChevronButtonState = .enabled,
        action: @escaping () -> Void
    ) {
        self.model = model
        self.direction = direction
        self.state = state
        self.action = action
        self.content = nil
    }
}

// MARK:- Body
public extension VChevronButton {
    var body: some View {
        VCircularButton(model: model.circularButtonModel, state: state, action: action, content: {
            Group(content: {
                switch content {
                case nil: defaultChevronButton
                case let content?: content()
                }
            })
                .frame(dimension: model.layout.iconDimension)
        })
    }
    
    private var defaultChevronButton: some View {
        Image(systemName: "chevron.up")
            .rotationEffect(.init(degrees: direction.angle))
    }
}

// MARK:- Rotation
private extension VChevronButtonDirection {
    var angle: Double {
        switch self {
        case .up: return 0
        case .right: return 90
        case .down: return 180
        case .left: return -90
        }
    }
}

// MARK:- Preview
struct VChevronButton_Previews: PreviewProvider {
    static var previews: some View {
        VChevronButton(direction: .left, action: {})
    }
}
