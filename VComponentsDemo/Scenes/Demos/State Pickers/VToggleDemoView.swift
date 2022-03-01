//
//  VToggleDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VComponents

// MARK: - V Toggle Demo View
struct VToggleDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "Toggle" }
    
    @State private var isEnabled: Bool = true
    @State private var state: VToggleState = .off
    @State private var contentType: VToggleContent = .title
    @State private var contentIsClickable: Bool = VToggleModel.Misc().contentIsClickable
    
    private var model: VToggleModel {
        var model: VToggleModel = .init()
        
        model.misc.contentIsClickable = contentIsClickable
        
        return model
    }

    // MARK: Body
    var body: some View {
        DemoView(component: component, settings: settings)
            .standardNavigationTitle(Self.navBarTitle)
    }
    
    private func component() -> some View {
        Group(content: {
            switch contentType {
            case .empty: VToggle(model: model, state: $state)
            case .title: VToggle(model: model, state: $state, title: toggleTitle)
            case .custom: VToggle(model: model, state: $state, content: { toggleIcon })
            }
        })
            .disabled(!isEnabled)
    }
    
    @ViewBuilder private func settings() -> some View {
        VSegmentedPicker(
            selection: .init(
                get: { _VToggleState(isEnabled: isEnabled, state: state) },
                set: { state in
                    isEnabled = state != .disabled
                    self.state = state.state
                }
            ),
            headerTitle: "State"
        )
        
        VSegmentedPicker(selection: $contentType, headerTitle: "Content")
        
        ToggleSettingView(isOn: $contentIsClickable, title: "Clickable Content")
    }
    
    private var toggleIcon: Image { .init(systemName: "swift") }
    
    private var toggleTitle: String { "Lorem Ipsum" }
}

// MARK: - Helpers
private enum _VToggleState: Int, VPickableTitledItem {
    case off
    case on
    case disabled
    
    var pickerTitle: String {
        switch self {
        case .off: return "Off"
        case .on: return "On"
        case .disabled: return "Disabled"
        }
    }
    
    var state: VToggleState {
        switch self {
        case .off: return .off
        case .on: return .on
        case .disabled: return .off // Doesn't matter
        }
    }
    
    init(isEnabled: Bool, state: VToggleState) {
        switch (isEnabled, state) {
        case (false, _): self = .disabled
        case (true, .off): self = .off
        case (true, .on): self = .on
        @unknown default: fatalError()
        }
    }
}

enum VToggleContent: Int, VPickableTitledItem {
    case empty
    case title
    case custom
    
    var pickerTitle: String {
        switch self {
        case .empty: return "None"
        case .title: return "Title"
        case .custom: return "Custom"
        }
    }
}

// MARK: Preview
struct VToggleDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VToggleDemoView()
    }
}
