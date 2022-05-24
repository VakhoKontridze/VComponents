//
//  VSecondaryButtonDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 18.12.20.
//

import SwiftUI
import VComponents

// MARK: - V Secondary Button Demo View
struct VSecondaryButtonDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "Secondary Button" }
    
    @State private var isEnabled: Bool = true
    @State private var labelType: VSecondaryButtonLabel = .title
    @State private var hitBoxType: VSecondaryButtonHitBox = .init(value: VSecondaryButtonModel.Layout().hitBox.horizontal)
    @State private var borderType: VPrimaryButtonBorder = .borderless
    
    private var model: VSecondaryButtonModel {
        let defaultModel: VSecondaryButtonModel = .init()
        
        var model: VSecondaryButtonModel = .init()
        
        model.layout.hitBox.horizontal = {
            switch hitBoxType {
            case .clipped: return 0
            case .extended: return defaultModel.layout.hitBox.horizontal == 0 ? 5 : defaultModel.layout.hitBox.horizontal
            }
        }()
        model.layout.hitBox.vertical = model.layout.hitBox.horizontal

        if borderType == .bordered {
            model.layout.borderWidth = 1.5

            model.colors.background = .init(
                enabled: .init("PrimaryButtonBordered.Background.enabled"),
                pressed: .init("PrimaryButtonBordered.Background.pressed"),
                disabled: .init("PrimaryButtonBordered.Background.disabled")
            )

            model.colors.border = defaultModel.colors.background
            
            model.colors.title = model.colors.icon
            
            model.colors.icon = defaultModel.colors.background
        }

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
            case .title: VSecondaryButton(model: model, action: {}, title: buttonTitle)
            case .iconTitle: VSecondaryButton(model: model, action: {}, icon: buttonIcon, title: buttonTitle)
            case .custom: VSecondaryButton(model: model, action: {}, label: { buttonIcon })
            }
        })
            .disabled(!isEnabled)
    }
    
    @ViewBuilder private func settings() -> some View {
        VSegmentedPicker(
            selection: .init(
                get: { VSecondaryButtonInternalState(isEnabled: isEnabled) },
                set: { isEnabled = $0 == .enabled }
            ),
            headerTitle: "State"
        )
        
        VSegmentedPicker(selection: $labelType, headerTitle: "Label")
        
        VSegmentedPicker(selection: $hitBoxType, headerTitle: "Hit Box")
        
        VSegmentedPicker(selection: $borderType, headerTitle: "Border")
    }
    
    private var buttonIcon: Image { .init(systemName: "swift") }
    
    private var buttonTitle: String { "Lorem Ipsum" }
}

// MARK: - Helpers
enum VSecondaryButtonInternalState: Int, PickableTitledEnumeration {
    case enabled
    case disabled
    
    var pickerTitle: String {
        switch self {
        case .enabled: return "Enabled"
        case .disabled: return "Disabled"
        }
    }
    
    init(isEnabled: Bool) {
        switch isEnabled {
        case false: self = .disabled
        case true: self = .enabled
        }
    }
}

private typealias VSecondaryButtonLabel = VPrimaryButtonLabel

enum VSecondaryButtonHitBox: Int, PickableTitledEnumeration {
    case clipped
    case extended
    
    var pickerTitle: String {
        switch self {
        case .clipped: return "Clipped"
        case .extended: return "Extended"
        }
    }
    
    init(value: CGFloat) {
        switch value {
        case 0: self = .clipped
        default: self = .extended
        }
    }
}

// MARK: - Preview
struct VSecondaryButtonDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VSecondaryButtonDemoView()
    }
}
