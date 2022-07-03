//
//  VSecondaryButtonDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 18.12.20.
//

import SwiftUI
import VComponents
import VCore

// MARK: - V Secondary Button Demo View
struct VSecondaryButtonDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "Secondary Button" }
    
    @State private var isEnabled: Bool = true
    @State private var labelType: VSecondaryButtonLabel = .title
    @State private var hitBoxType: VSecondaryButtonHitBox = .init(value: VSecondaryButtonUIModel.Layout().hitBox.horizontal)
    @State private var borderType: VPrimaryButtonBorder = .borderless
    
    private var uiModel: VSecondaryButtonUIModel {
        let defaultUIModel: VSecondaryButtonUIModel = .init()
        
        var uiModel: VSecondaryButtonUIModel = .init()
        
        uiModel.layout.hitBox.horizontal = {
            switch hitBoxType {
            case .clipped: return 0
            case .extended: return defaultUIModel.layout.hitBox.horizontal == 0 ? 5 : defaultUIModel.layout.hitBox.horizontal
            }
        }()
        uiModel.layout.hitBox.vertical = uiModel.layout.hitBox.horizontal

        if borderType == .bordered {
            uiModel.layout.borderWidth = 1.5

            uiModel.colors.background = .init(
                enabled: .init("PrimaryButtonBordered.Background.enabled"),
                pressed: .init("PrimaryButtonBordered.Background.pressed"),
                disabled: .init("PrimaryButtonBordered.Background.disabled")
            )

            uiModel.colors.border = defaultUIModel.colors.background
            
            uiModel.colors.title = uiModel.colors.icon
            
            uiModel.colors.icon = defaultUIModel.colors.background
        }

        return uiModel
    }

    // MARK: Body
    var body: some View {
        DemoView(component: component, settings: settings)
            .standardNavigationTitle(Self.navBarTitle)
    }
    
    private func component() -> some View {
        Group(content: {
            switch labelType {
            case .title: VSecondaryButton(uiModel: uiModel, action: {}, title: buttonTitle)
            case .iconTitle: VSecondaryButton(uiModel: uiModel, action: {}, icon: buttonIcon, title: buttonTitle)
            case .custom: VSecondaryButton(uiModel: uiModel, action: {}, label: { buttonIcon })
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
enum VSecondaryButtonInternalState: Int, StringRepresentableHashableEnumeration {
    case enabled
    case disabled
    
    var stringRepresentation: String {
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

enum VSecondaryButtonHitBox: Int, StringRepresentableHashableEnumeration {
    case clipped
    case extended
    
    var stringRepresentation: String {
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
