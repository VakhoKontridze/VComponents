//
//  VRoundedLabeledButtonDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 17.08.22.
//

import SwiftUI
import VComponents
import VCore

// MARK: - V Rounded Labeled Button Demo View
struct VRoundedLabeledButtonDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "Rounded Labeled Button" }
    
    @State private var isEnabled: Bool = true
    @State private var labelType: VRoundedLabeledButtonLabel = .title
    @State private var borderType: VPrimaryButtonBorder = .borderless
    
    private var uiModel: VRoundedLabeledButtonUIModel {
        let defaultUIModel: VRoundedLabeledButtonUIModel = .init()
        
        var uiModel: VRoundedLabeledButtonUIModel = .init()

        if borderType == .bordered {
            uiModel.layout.borderWidth = 1

            uiModel.colors.border = defaultUIModel.colors.icon
        }

        if labelType == .iconTitle {
            uiModel.layout.labelWidthMax = .infinity
            uiModel.layout.titleLabelLineType = .singleLine
        }

        return uiModel
    }

    // MARK: Body
    var body: some View {
        DemoView(component: component, settings: settings)
            .inlineNavigationTitle(Self.navBarTitle)
    }
    
    private func component() -> some View {
        Group(content: {
            switch labelType {
            case .title: VRoundedLabeledButton(uiModel: uiModel, action: {}, icon: buttonIcon, titleLabel: buttonTitle)
            case .iconTitle: VRoundedLabeledButton(uiModel: uiModel, action: {}, icon: buttonIcon, iconLabel: buttonIcon, titleLabel: buttonTitle)
            case .custom: VRoundedLabeledButton(uiModel: uiModel, action: {}, icon: buttonIcon, label: { buttonIcon })
            }
        })
            .disabled(!isEnabled)
    }
    
    @ViewBuilder private func settings() -> some View {
        VSegmentedPicker(
            selection: .init(
                get: { VRoundedLabeledButtonInternalState(isEnabled: isEnabled) },
                set: { isEnabled = $0 == .enabled }
            ),
            headerTitle: "State"
        )
        
        VSegmentedPicker(selection: $labelType, headerTitle: "Label")
        
        VSegmentedPicker(selection: $borderType, headerTitle: "Border")
    }
    
    private var buttonIcon: Image { .init(systemName: "swift") }
    
    private var buttonTitle: String { "Lorem Ipsum" }
}

// MARK: - Helpers
private typealias VRoundedLabeledButtonInternalState = VSecondaryButtonInternalState

private typealias VRoundedLabeledButtonLabel = VPrimaryButtonLabel

// MARK: - Preview
struct VRoundedLabeledButtonDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VRoundedLabeledButtonDemoView()
    }
}
