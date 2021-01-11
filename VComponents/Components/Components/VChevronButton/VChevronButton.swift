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
    @State private var isPressed: Bool = false
    private var internalState: VChevronButtonInternalState { .init(state: state, isPressed: isPressed) }
    
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
extension VChevronButton {
    public var body: some View {
        VBaseButton(
            isDisabled: state.isDisabled,
            action: action,
            onPress: { isPressed = $0 },
            content: { hitBox }
        )
    }
    
    private var hitBox: some View {
        buttonView
            .padding(.horizontal, model.layout.hitBoxSpacingX)
            .padding(.vertical, model.layout.hitBoxSpacingY)
    }
    
    private var buttonView: some View {
        buttonContent
            .frame(dimension: model.layout.dimension)
            .background(backgroundView)
    }
    
    private var buttonContent: some View {
        Image(systemName: "chevron.up")
            .font(model.font)
            .foregroundColor(model.colors.foregroundColor(state: internalState))
            .opacity(model.colors.foregroundOpacity(state: internalState))
            .rotationEffect(.init(degrees: direction.angle))
    }
    
    private var backgroundView: some View {
        Circle()
            .foregroundColor(model.colors.backgroundColor(state: internalState))
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
