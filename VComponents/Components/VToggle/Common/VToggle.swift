//
//  VToggle.swift
//  VComponents
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI

// MARK:- V Toggle
public struct VToggle<Content>: View where Content: View {
    // MARK: Properties
    private let toggleType: VToggleType
    
    @Binding private var isOn: Bool
    private let state: VToggleState
    
    private let content: (() -> Content)?
    
    // MARK: Initializers
    public init(
        _ toggleType: VToggleType,
        isOn: Binding<Bool>,
        state: VToggleState,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.toggleType = toggleType
        self._isOn = isOn
        self.state = state
        self.content = content
    }
}

public extension VToggle where Content == Text {
    init<S>(
        _ toggleType: VToggleType,
        isOn: Binding<Bool>,
        state: VToggleState,
        title: S
    )
        where S: StringProtocol
    {
        self.init(
            toggleType,
            isOn: isOn,
            state: state,
            content: { Text(title) }
        )
    }
}

public extension VToggle where Content == Never {
    init(
        isOn: Binding<Bool>,
        state: VToggleState
    ) {
        self.toggleType = .rightContent()
        self._isOn = isOn
        self.state = state
        self.content = nil
    }
}

// MARK:- Body
public extension VToggle {
    @ViewBuilder var body: some View {
        switch toggleType {
        case .rightContent(let viewModel): VToggleRightContent(viewModel: viewModel, isOn: $isOn, state: state, content: content)
        case .spacedLeftContent(let viewModel): VToggleLeftFlexibleContent(viewModel: viewModel, isOn: $isOn, state: state, content: content)
        }
    }
}

// MARK:- Preview
struct VToggle_Previews: PreviewProvider {
    @State private static var isOn: Bool = true
    
    static var previews: some View {
        VToggle(.rightContent(), isOn: $isOn, state: .enabled, title: "Toggle")
    }
}
