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
    @State private var hitBoxType: VRadioButtonHitBox = .init(value: VRadioButtonUIModel.Layout().hitBox)
    @State private var labelIsClickable: Bool = VRadioButtonUIModel.Misc().labelIsClickable
    
    private var uiModel: VRadioButtonUIModel {
        let defaultUIModel: VRadioButtonUIModel = .init()
        
        var uiModel: VRadioButtonUIModel = .init()
        
        uiModel.layout.hitBox = {
            switch hitBoxType {
            case .clipped: return 0
            case .extended: return defaultUIModel.layout.hitBox == 0 ? 5 : defaultUIModel.layout.hitBox
            }
        }()
        if hitBoxType == .clipped {
            uiModel.layout.radioLabelSpacing = defaultUIModel.layout.hitBox.isZero ? 5 : defaultUIModel.layout.hitBox
        }
        
        uiModel.misc.labelIsClickable = labelIsClickable
        
        return uiModel
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
            case .empty: VRadioButton(uiModel: uiModel, state: $state)
            case .title: VRadioButton(uiModel: uiModel, state: $state, title: radioButtonTitle)
            case .custom: VRadioButton(uiModel: uiModel, state: $state, label: { radioButtonIcon })
            }
        })
            .disabled(!isEnabled)
    }
    
    @ViewBuilder private func settings() -> some View {
        VSegmentedPicker(
            selection: .init(
                get: { VRadioButtonInternalState(isEnabled: isEnabled, state: state) },
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
private enum VRadioButtonInternalState: Int, PickableTitledEnumeration {
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
