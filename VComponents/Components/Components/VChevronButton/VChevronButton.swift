//
//  VChevronButton.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 12/22/20.
//

import SwiftUI

// MARK:- V Chevron Button
public struct VChevronButton: View {
    // MARK: Properties
    private let model: VChevronButtonModel
    
    private let direction: VChevronButtonDirection
    private let state: VChevronButtonState
    
    private let action: () -> Void
    
    // MARK: Direction
    public init(
        model: VChevronButtonModel = .init(),
        direction: VChevronButtonDirection,
        state: VChevronButtonState = .enabled,
        action: @escaping () -> Void
    ) {
        self.model = model
        self.direction = direction
        self.state = state
        self.action = action
    }
}

// MARK:- Body
public extension VChevronButton {
    var body: some View {
        VSquareButton(
            model: model.squareButtonModel,
            state: state,
            action: action,
            content: { buttonView } // Hitbox is applied on VSquareButton in model
        )
    }

    private var buttonView: some View {
        Image(systemName: "chevron.up")
            .frame(dimension: model.layout.iconDimension)
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
        VChevronButton(direction: .right, action: {})
            .padding()
    }
}
