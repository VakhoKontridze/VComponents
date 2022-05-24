//
//  VPlainButtonDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 18.12.20.
//

import SwiftUI
import VComponents

// MARK: - V Plain Button Demo View
struct VPlainButtonDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "Plain Button" }
    
    @State private var isEnabled: Bool = true
    @State private var labelType: VPlainButtonLabel = .title
    @State private var hitBoxType: VSecondaryButtonHitBox = .init(value: VPlainButtonModel.Layout().hitBox.horizontal)
    
    private var model: VPlainButtonModel {
        let defaultModel: VPlainButtonModel = .init()
        
        var model: VPlainButtonModel = .init()
        
        model.layout.hitBox.horizontal = {
            switch hitBoxType {
            case .clipped: return 0
            case .extended: return defaultModel.layout.hitBox.horizontal == 0 ? 5 : defaultModel.layout.hitBox.horizontal
            }
        }()
        model.layout.hitBox.vertical = model.layout.hitBox.horizontal

        return model
    }

    // MARK: Body
    var body: some View {
        DemoView(component: component, settings: settings)
            .standardNavigationTitle(Self.navBarTitle)
    }
    
    private func component() -> some View {
        Group(content: {
            switch labelType {
            case .title: VPlainButton(model: model, action: {}, title: buttonTitle)
            case .icon: VPlainButton(model: model, action: {}, icon: buttonIcon)
            case .iconTitle: VPlainButton(model: model, action: {}, icon: buttonIcon, title: buttonTitle)
            case .custom: VPlainButton(model: model, action: {}, label: { buttonIcon })
            }
        })
            .disabled(!isEnabled)
    }
    
    @ViewBuilder private func settings() -> some View {
        VSegmentedPicker(
            selection: .init(
                get: { VPlainButtonInternalState(isEnabled: isEnabled) },
                set: { isEnabled = $0 == .enabled }
            ),
            headerTitle: "State"
        )
        
        VSegmentedPicker(selection: $labelType, headerTitle: "Label")
        
        VSegmentedPicker(selection: $hitBoxType, headerTitle: "Hit Box")
    }
    
    private var buttonIcon: Image { .init(systemName: "swift") }
    
    private var buttonTitle: String { "Lorem" }
}

// MARK: - Helpers
private typealias VPlainButtonInternalState = VSecondaryButtonInternalState

private enum VPlainButtonLabel: Int, PickableTitledEnumeration {
    case title
    case icon
    case iconTitle
    case custom
    
    var pickerTitle: String {
        switch self {
        case .title: return "Title"
        case .icon: return "Icon"
        case .iconTitle: return "Icon & Title"
        case .custom: return "Custom"
        }
    }
}

// MARK: - Preview
struct VPlainButtonDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VPlainButtonDemoView()
    }
}
