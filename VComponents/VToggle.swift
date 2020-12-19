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
    @Binding private var isOn: Bool
    private let state: VToggleState
    
    private let viewModel: VToggleViewModel
    
    private let content: (() -> Content)?
    
    // MARK: Initializers
    public init(
        isOn: Binding<Bool>,
        state: VToggleState,
        viewModel: VToggleViewModel,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._isOn = isOn
        self.state = state
        self.viewModel = viewModel
        self.content = content
    }
}

public extension VToggle where Content == Never {
    init(
        isOn: Binding<Bool>,
        state: VToggleState,
        viewModel: VToggleViewModel
    ) {
        self._isOn = isOn
        self.state = state
        self.viewModel = viewModel
        self.content = nil
    }
}

public extension VToggle where Content == Text {
    init<S>(
        isOn: Binding<Bool>,
        state: VToggleState,
        viewModel: VToggleViewModel,
        title: S
    )
        where S: StringProtocol
    {
        self.init(
            isOn: isOn,
            state: state,
            viewModel: viewModel,
            content: { Text(title) }
        )
    }
}

// MARK:- Body
public extension VToggle {
    var body: some View {
        Group(content: {
            switch (viewModel.layout.contentLayout, content) {
            case (.right, nil): plainToggle
            case (.right(let spacing), let content?): rightContentToggle(spacing: spacing, content: content)
            
            case (.leftFlexible, _): leftFlexibleContentToggle(content: content)
            }
        })
            .disabled(!state.isEnabled)
    }
    
    private var plainToggle: some View {
        toggle
    }
    
    private func rightContentToggle(spacing: CGFloat, content: @escaping () -> Content) -> some View {
        HStack(alignment: .center, spacing: spacing, content: {
            toggle
            toggleContent(from: content)
        })
    }

    private func leftFlexibleContentToggle(content: (() -> Content)?) -> some View {
        HStack(alignment: .center, spacing: 0, content: {
            toggleContent(from: content)
            Spacer()
            toggle
        })
    }
    
    private var toggle: some View {
        Toggle(isOn: $isOn, label: { EmptyView() })
            .labelsHidden()
            .toggleStyle(SwitchToggleStyle(tint: VToggleViewModel.Colors.toggle(state: state, vm: viewModel)))
    }
    
    private func toggleContent(from content: (() -> Content)?) -> some View {
        Group(content: {
            switch viewModel.behavior.contentIsClickable {
            case false:
                content?()
                
            case true:
                content?()
                    .contentShape(Rectangle())
                    .onTapGesture(count: 1, perform: { withAnimation { isOn.toggle() } })
            }
        })
            .opacity(state.isEnabled ? 1 : 0.25)
    }
}

// MARK:- Preview
struct VToggle_Previews: PreviewProvider {
    static var previews: some View {
        VToggle(
            isOn: .constant(true),
            state: .enabled,
            viewModel: .init(),
            title: "Toggle"
        )
    }
}

// MARK:- ViewModel Mapping
private extension VToggleViewModel.Colors {
    static func toggle(state: VToggleState, vm: VToggleViewModel) -> Color {
        switch state {
        case .enabled: return vm.colors.toggle.enabled
        case .disabled: return vm.colors.toggle.disabled
        }
    }
}
