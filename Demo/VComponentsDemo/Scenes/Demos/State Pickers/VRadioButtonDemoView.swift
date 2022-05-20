//
//  VRadioButtonDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VComponents
import VCore

// MARK: - V RadioButton Demo View
struct VRadioButtonDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "Radio Button" }
    
    @State private var isEnabled: Bool = true
    @State private var state: VRadioButtonState = .off
    @State private var labelType: VRadioButtonLabel = .title
    @State private var hitBoxType: VRadioButtonHitBox = .init(value: VRadioButtonModel.Layout().hitBox)
    @State private var labelIsClickable: Bool = VRadioButtonModel.Misc().labelIsClickable
    
    private var model: VRadioButtonModel {
        let defaultModel: VRadioButtonModel = .init()
        
        var model: VRadioButtonModel = .init()
        
        model.layout.hitBox = {
            switch hitBoxType {
            case .clipped: return 0
            case .extended: return defaultModel.layout.hitBox == 0 ? 5 : defaultModel.layout.hitBox
            }
        }()
        if hitBoxType == .clipped {
            model.layout.radioLabelSpacing = defaultModel.layout.hitBox.isZero ? 5 : defaultModel.layout.hitBox
        }
        
        model.misc.labelIsClickable = labelIsClickable
        
        return model
    }

    // MARK: Body
    var body: some View {
        DemoView(component: component, settings: settings)
            .standardNavigationTitle(Self.navBarTitle)
            .bindToModalContext(state)
    }
    
    private func component() -> some View {
        Group(content: {
            switch labelType {
            case .empty: VRadioButton(model: model, state: $state)
            case .title: VRadioButton(model: model, state: $state, title: radioButtonTitle)
            case .custom: VRadioButton(model: model, state: $state, label: { radioButtonIcon })
            }
        })
            .disabled(!isEnabled)
    }
    
    @ViewBuilder private func settings() -> some View {
        VSegmentedPicker(
            selection: .init(
                get: { _VRadioButtonState(isEnabled: isEnabled, state: state) },
                set: { state in
                    isEnabled = state != .disabled
                    self.state = state.state
                }
            ),
            headerTitle: "State"
        )
        
        VSegmentedPicker(selection: $labelType, headerTitle: "Label")
        
        ToggleSettingView(isOn: $labelIsClickable, title: "Clickable Label")
    }
    
    private var radioButtonIcon: Image { .init(systemName: "swift") }
    
    private var radioButtonTitle: String { "Lorem Ipsum" }
}

// MARK: - Helpers
private enum _VRadioButtonState: Int, PickableTitledEnumeration {
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
    
    var state: VRadioButtonState {
        switch self {
        case .off: return .off
        case .on: return .on
        case .disabled: return .off // Doesn't matter
        }
    }
    
    init(isEnabled: Bool, state: VRadioButtonState) {
        switch (isEnabled, state) {
        case (false, _): self = .disabled
        case (true, .off): self = .off
        case (true, .on): self = .on
        }
    }
}

private typealias VRadioButtonLabel = VToggleLabel

private typealias VRadioButtonHitBox = VSecondaryButtonHitBox

// MARK: Preview
struct VRadioButtonDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VRadioButtonDemoView()
    }
}
