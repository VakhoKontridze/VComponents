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
    private let buttonType: VChevronButtonType
    
    private let direction: VChevronButtonDirection
    private let state: VChevronButtonState
    
    private let action: () -> Void
    
    private let content: (() -> Content)?
    
    // MARK: Direction
    public init(
        _ buttonType: VChevronButtonType = .default,
        direction: VChevronButtonDirection,
        state: VChevronButtonState = .enabled,
        action: @escaping () -> Void,
        content: @escaping () -> Content
    ) {
        self.buttonType = buttonType
        self.direction = direction
        self.state = state
        self.action = action
        self.content = content
    }

    public init(
        _ buttonType: VChevronButtonType = .default,
        direction: VChevronButtonDirection,
        state: VChevronButtonState = .enabled,
        action: @escaping () -> Void
    )
        where Content == Never
    {
        self.buttonType = buttonType
        self.direction = direction
        self.state = state
        self.action = action
        self.content = nil
    }
}

// MARK:- Body
public extension VChevronButton {
    @ViewBuilder var body: some View {
        switch buttonType {
        case .filled(let model): VChevronButtonFilled(model: model, direction: direction, state: state, action: action, content: { chevronButtonContent })
        case .plain(let model): VChevronButtonPlain(model: model, direction: direction, state: state, action: action, content: { chevronButtonContent })
        }
    }

    @ViewBuilder private var chevronButtonContent: some View {
        switch content {
        case nil:
            Image(systemName: "chevron.up")
                .rotationEffect(.init(degrees: direction.angle))
        
        case let content?:
            content()
        }
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
//struct VChevronButton_Previews: PreviewProvider {
//    static var previews: some View {
//        VStack(content: {
//            VChevronButtonFilled_Previews.previews
//            VChevronButtonPlain_Previews.previews
//        })
//            .padding()
//    }
//}
