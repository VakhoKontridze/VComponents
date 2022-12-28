//
//  VPrimaryButtonDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 18.12.20.
//

import SwiftUI
import VComponents
import VCore

// MARK: - V Primary Button Demo View
struct VPrimaryButtonDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "Primary Button" }
    
    @State private var isEnabled: Bool = true
    @State private var isLoading: Bool = false
    @State private var labelType: VPrimaryButtonLabel = .title
    @State private var borderType: VPrimaryButtonBorder = .borderless
    
    private var uiModel: VPrimaryButtonUIModel {
        let defaultUIModel: VPrimaryButtonUIModel = .init()
        
        var uiModel: VPrimaryButtonUIModel = .init()

        if borderType == .bordered {
            uiModel.layout.borderWidth = 1.5

            uiModel.colors.background = .init(
                enabled: .init("PrimaryButtonBordered.Background.enabled"),
                pressed: .init("PrimaryButtonBordered.Background.pressed"),
                loading: .init("PrimaryButtonBordered.Background.disabled"),
                disabled: .init("PrimaryButtonBordered.Background.disabled")
            )

            uiModel.colors.border = defaultUIModel.colors.background
            
            uiModel.colors.title = defaultUIModel.colors.background
            
            uiModel.colors.icon = defaultUIModel.colors.background
            
            uiModel.colors.loader = uiModel.colors.icon.disabled
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
            case .title: VPrimaryButton(uiModel: uiModel, isLoading: isLoading, action: {}, title: buttonTitle)
            case .iconTitle: VPrimaryButton(uiModel: uiModel, isLoading: isLoading, action: {}, icon: buttonIcon, title: buttonTitle)
            case .custom: VPrimaryButton(uiModel: uiModel, isLoading: isLoading, action: {}, label: { buttonIcon })
            }
        })
            .disabled(!isEnabled)
    }
    
    @ViewBuilder private func settings() -> some View {
        VSegmentedPicker(
            selection: .init(
                get: { VPrimaryButtonInternalState(isEnabled: isEnabled, isLoading: isLoading) },
                set: { state in
                    isEnabled = state != .disabled // Loading is also type of disabled
                    isLoading = state == .loading
                }
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
private enum VPrimaryButtonInternalState: Int, StringRepresentableHashableEnumeration {
    case enabled
    case loading
    case disabled
    
    var stringRepresentation: String {
        switch self {
        case .enabled: return "Enabled"
        case .loading: return "Loading"
        case .disabled: return "Disabled"
        }
    }
    
    init(isEnabled: Bool, isLoading: Bool) {
        switch (isEnabled, isLoading) {
        case (false, false): self = .disabled
        case (_, true): self = .loading
        case (true, false): self = .enabled
        }
    }
}

enum VPrimaryButtonLabel: Int, StringRepresentableHashableEnumeration {
    case title
    case iconTitle
    case custom
    
    var stringRepresentation: String {
        switch self {
        case .title: return "Title"
        case .iconTitle: return "Icon & Title"
        case .custom: return "Custom"
        }
    }
}

enum VPrimaryButtonBorder: Int, StringRepresentableHashableEnumeration {
    case borderless
    case bordered
    
    var stringRepresentation: String {
        switch self {
        case .borderless: return "Borderless"
        case .bordered: return "Bordered"
        }
    }
}

// MARK: - Preview
struct VPrimaryButtonDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VPrimaryButtonDemoView()
    }
}
