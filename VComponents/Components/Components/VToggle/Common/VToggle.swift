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
        _ toggleType: VToggleType = .default,
        isOn: Binding<Bool>,
        state: VToggleState = .enabled,
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
        _ toggleType: VToggleType = .default,
        isOn: Binding<Bool>,
        state: VToggleState = .enabled,
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
        state: VToggleState = .enabled
    ) {
        self.toggleType = .default
        self._isOn = isOn
        self.state = state
        self.content = nil
    }
}

// MARK:- Body
public extension VToggle {
    @ViewBuilder var body: some View {
        switch toggleType {
        case .standard(let model): VToggleStandard(model: model, isOn: $isOn, state: state, content: content)
        case .setting(let model): VToggleSetting(model: model, isOn: $isOn, state: state, content: content)
        }
    }
}

// MARK:- Preview
struct VToggle_Previews: PreviewProvider {
    @State private static var isOn: Bool = true
    
    static var previews: some View {
        VToggle(isOn: $isOn, title: "Toggle")
    }
}
