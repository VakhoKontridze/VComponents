//
//  VCheckBoxDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VComponents
import VCore

// MARK: - V CheckBox Demo View
struct VCheckBoxDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "CheckBox" }
    
    @State private var isEnabled: Bool = true
    @State private var state: VCheckBoxState = .off
    @State private var labelType: VCheckBoxLabel = .title
    @State private var hitBoxType: VCheckBoxHitBox = .init(value: VCheckBoxUIModel.Layout().hitBox)
    @State private var labelIsClickable: Bool = VCheckBoxUIModel.Misc().labelIsClickable
    
    private var uiModel: VCheckBoxUIModel {
        let defaultUIModel: VCheckBoxUIModel = .init()
        
        var uiModel: VCheckBoxUIModel = .init()
        
        uiModel.layout.hitBox = {
            switch hitBoxType {
            case .clipped: return 0
            case .extended: return defaultUIModel.layout.hitBox == 0 ? 5 : defaultUIModel.layout.hitBox
            }
        }()
        if hitBoxType == .clipped {
            uiModel.layout.checkBoxLabelSpacing = defaultUIModel.layout.hitBox.isZero ? 5 : defaultUIModel.layout.hitBox
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
            case .empty: VCheckBox(uiModel: uiModel, state: $state)
            case .title: VCheckBox(uiModel: uiModel, state: $state, title: checkBoxTitle)
            case .custom: VCheckBox(uiModel: uiModel, state: $state, label: { checkBoxIcon })
            }
        })
            .disabled(!isEnabled)
    }
    
    @ViewBuilder private func settings() -> some View {
        VSegmentedPicker(
            selection: .init(
                get: { VCheckBoxInternalState(isEnabled: isEnabled, state: state) },
                set: { state in
                    isEnabled = state != .disabled
                    self.state = state.state
                }
            ),
            headerTitle: "State"
        )
        
        VSegmentedPicker(selection: $labelType, headerTitle: "Label")
        
        VSegmentedPicker(selection: $hitBoxType, headerTitle: "Hit Box")
        
        ToggleSettingView(isOn: $labelIsClickable, title: "Clickable Label")
    }
    
    private var checkBoxIcon: Image { .init(systemName: "swift") }
    
    private var checkBoxTitle: String { "Lorem Ipsum" }
}

// MARK: - Helpers
private enum VCheckBoxInternalState: Int, PickableTitledEnumeration {
    case off
    case on
    case indeterminate
    case disabled
    
    var pickerTitle: String {
        switch self {
        case .off: return "Off"
        case .on: return "On"
        case .indeterminate: return "Indtrm."
        case .disabled: return "Disabled"
        }
    }
    
    var state: VCheckBoxState {
        switch self {
        case .off: return .off
        case .on: return .on
        case .indeterminate: return .indeterminate
        case .disabled: return .off // Doesn't matter
        }
    }
    
    init(isEnabled: Bool, state: VCheckBoxState) {
        switch (isEnabled, state) {
        case (false, _): self = .disabled
        case (true, .off): self = .off
        case (true, .on): self = .on
        case (true, .indeterminate): self = .indeterminate
        }
    }
}

private typealias VCheckBoxLabel = VToggleLabel

private typealias VCheckBoxHitBox = VSecondaryButtonHitBox

// MARK: Preview
struct VCheckBoxDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VCheckBoxDemoView()
    }
}
