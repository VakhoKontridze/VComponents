//
//  VCheckBoxDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 19.12.20.
//

import SwiftUI
import VComponents

// MARK: - V CheckBox Demo View
struct VCheckBoxDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "CheckBox" }
    
    @State private var isEnabled: Bool = true
    @State private var state: VCheckBoxState = .off
    @State private var contentType: VCheckBoxContent = .title
    @State private var hitBoxType: VCheckBoxHitBox = .init(value: VCheckBoxModel.Layout().hitBox)
    @State private var contentIsClickable: Bool = VCheckBoxModel.Misc().contentIsClickable
    
    private var model: VCheckBoxModel {
        let defaultModel: VCheckBoxModel = .init()
        
        var model: VCheckBoxModel = .init()
        
        model.layout.hitBox = {
            switch hitBoxType {
            case .clipped: return 0
            case .extended: return defaultModel.layout.hitBox == 0 ? 5 : defaultModel.layout.hitBox
            }
        }()
        if hitBoxType == .clipped {
            model.layout.contentMarginLeading = defaultModel.layout.hitBox.isZero ? 5 : defaultModel.layout.hitBox
        }
        
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
            case .empty: VCheckBox(model: model, state: $state)
            case .title: VCheckBox(model: model, state: $state, title: checkBoxTitle)
            case .custom: VCheckBox(model: model, state: $state, content: { checkBoxIcon })
            }
        })
            .disabled(!isEnabled)
    }
    
    @ViewBuilder private func settings() -> some View {
        VSegmentedPicker(
            selection: .init(
                get: { _VCheckBoxState(isEnabled: isEnabled, state: state) },
                set: { state in
                    isEnabled = state != .disabled
                    self.state = state.state
                }
            ),
            headerTitle: "State"
        )
        
        VSegmentedPicker(selection: $contentType, headerTitle: "Content")
        
        VSegmentedPicker(selection: $hitBoxType, headerTitle: "Hit Box")
        
        ToggleSettingView(isOn: $contentIsClickable, title: "Clickable Content")
    }
    
    private var checkBoxIcon: Image { .init(systemName: "swift") }
    
    private var checkBoxTitle: String { "Lorem Ipsum" }
}

// MARK: - Helpers
private enum _VCheckBoxState: Int, PickableTitledEnumeration {
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
        @unknown default: fatalError()
        }
    }
}

private typealias VCheckBoxContent = VToggleContent

private typealias VCheckBoxHitBox = VSecondaryButtonHitBox

// MARK: Preview
struct VCheckBoxDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VCheckBoxDemoView()
    }
}
