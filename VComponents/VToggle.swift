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
    private let toggleType: VToggleType?
    private let viewModel: VToggleViewModel
    
    @Binding private var isOn: Bool
    private let state: VToggleState
    
    private let content: (() -> Content)?
    
    // MARK: Initializers
    public init(
        _ toggleType: VToggleType,
        viewModel: VToggleViewModel = .init(),
        isOn: Binding<Bool>,
        state: VToggleState,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.toggleType = toggleType
        self.viewModel = viewModel
        self._isOn = isOn
        self.state = state
        self.content = content
    }
}

public extension VToggle where Content == Text {
    init<S>(
        _ toggleType: VToggleType,
        viewModel: VToggleViewModel = .init(),
        isOn: Binding<Bool>,
        state: VToggleState,
        title: S
    )
        where S: StringProtocol
    {
        self.init(
            toggleType,
            viewModel: viewModel,
            isOn: isOn,
            state: state,
            content: { Text(title) }
        )
    }
}

public extension VToggle where Content == Never {
    init(
        viewModel: VToggleViewModel = .init(),
        isOn: Binding<Bool>,
        state: VToggleState
    ) {
        self.toggleType = nil
        self.viewModel = viewModel
        self._isOn = isOn
        self.state = state
        self.content = nil
    }
}

// MARK:- Body
public extension VToggle {
    var body: some View {
        Group(content: {
            switch (toggleType, content) {
            case (nil, _): plainToggle
            
            case (.rightContent, nil): plainToggle
            case (.rightContent, let content?): rightContentToggle(content: content)
            
            case (.spacedLeftContent, _): spacedLeftContentToggle(content: content)
            }
        })
            .disabled(!state.isEnabled)
    }
    
    private var plainToggle: some View {
        toggle
    }
    
    private func rightContentToggle(content: @escaping () -> Content) -> some View {
        HStack(alignment: .center, spacing: viewModel.layout.rightContent.spacing, content: {
            toggle
            toggleContent(from: content)
        })
    }

    private func spacedLeftContentToggle(content: (() -> Content)?) -> some View {
        HStack(alignment: .center, spacing: 0, content: {
            toggleContent(from: content)
            Spacer()
            toggle
        })
    }
    
    private var toggle: some View {
        VPlainButton(viewModel: viewModel.plainButtonViewModel, state: .enabled, action: action, content: {
            ZStack(content: {
                RoundedRectangle(cornerRadius: viewModel.layout.common.size.height)
                    .foregroundColor(VToggleViewModel.Colors.fill(isOn: isOn, state: state, vm: viewModel))
                
                Circle()
                    .frame(dimension: viewModel.layout.common.thumbDimension)
                    .foregroundColor(VToggleViewModel.Colors.thumb(isOn: isOn, state: state, vm: viewModel))
                    .offset(
                        x: isOn ? viewModel.layout.common.animationOffset : -viewModel.layout.common.animationOffset,
                        y: 0
                    )
            })
                .frame(size: viewModel.layout.common.size)
        })
    }
    
    private func toggleContent(from content: (() -> Content)?) -> some View {
        content?()
            .opacity(state.isEnabled ? 1 : viewModel.behavior.disabledOpacity)
    }
}

// MARK:- Action
private extension VToggle {
    func action() {
        withAnimation(Animation.easeIn(duration: 0.1), { isOn.toggle() })
    }
}

// MARK:- Preview
struct VToggle_Previews: PreviewProvider {
    static var previews: some View {
        VToggle(.rightContent, isOn: .constant(true), state: .enabled, title: "Toggle")
    }
}
