//
//  VRoundedButtonDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 18.12.20.
//

import SwiftUI
import VComponents
import VCore

// MARK: - V Rounded Button Demo View
struct VRoundedButtonDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "Rounded Button" }
    
    @State private var isEnabled: Bool = true
    @State private var labelType: VRoundedButtonLabel = .title
    @State private var hitBoxType: VSecondaryButtonHitBox = .init(value: VRoundedButtonUIModel.Layout().hitBox.horizontal)
    @State private var borderType: VPrimaryButtonBorder = .borderless
    
    private var uiModel: VRoundedButtonUIModel {
        let defaultUIModel: VRoundedButtonUIModel = .init()
        
        var uiModel: VRoundedButtonUIModel = .init()
        
        uiModel.layout.hitBox.horizontal = {
            switch hitBoxType {
            case .clipped: return 0
            case .extended: return defaultUIModel.layout.hitBox.horizontal == 0 ? 5 : defaultUIModel.layout.hitBox.horizontal
            }
        }()
        uiModel.layout.hitBox.vertical = uiModel.layout.hitBox.horizontal

        if borderType == .bordered {
            uiModel.layout.borderWidth = 1
            
            uiModel.colors.background = .init(
                enabled: .init("PrimaryButtonBordered.Background.enabled"),
                pressed: .init("PrimaryButtonBordered.Background.pressed"),
                disabled: .init("PrimaryButtonBordered.Background.disabled")
            )

            uiModel.colors.border = defaultUIModel.colors.background
            
            uiModel.colors.title = defaultUIModel.colors.background
            
            uiModel.colors.icon = defaultUIModel.colors.background
        }

        return uiModel
    }

    // MARK: Body
    var body: some View {
        DemoView(
            component: component,
            settings: settings
        )
            .inlineNavigationTitle(Self.navBarTitle)
    }
    
    private func component() -> some View {
        Group(content: {
            switch labelType {
            case .title: VRoundedButton(uiModel: uiModel, action: {}, title: buttonTitle)
            case .icon: VRoundedButton(uiModel: uiModel, action: {}, icon: buttonIcon)
            case .custom: VRoundedButton(uiModel: uiModel, action: {}, label: { buttonIcon })
            }
        })
            .disabled(!isEnabled)
    }
    
    @ViewBuilder private func settings() -> some View {
        VSegmentedPicker(
            selection: .init(
                get: { VRoundedButtonInternalState(isEnabled: isEnabled) },
                set: { isEnabled = $0 == .enabled }
            ),
            headerTitle: "State"
        )
        
        VSegmentedPicker(selection: $labelType, headerTitle: "Label")
        
        VSegmentedPicker(selection: $hitBoxType, headerTitle: "Hit Box")
        
        VSegmentedPicker(selection: $borderType, headerTitle: "Border")
    }
    
    private var buttonIcon: Image { .init(systemName: "swift") }
    
    private var buttonTitle: String { "Lorem" }
}

// MARK: - Helpers
private typealias VRoundedButtonInternalState = VSecondaryButtonInternalState

enum VRoundedButtonLabel: Int, StringRepresentableHashableEnumeration {
    case title
    case icon
    case custom
    
    var stringRepresentation: String {
        switch self {
        case .title: return "Title"
        case .icon: return "Icon"
        case .custom: return "Custom"
        }
    }
}

// MARK: - Preview
struct VRoundedButtonDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VRoundedButtonDemoView()
    }
}
