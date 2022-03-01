//
//  VPrimaryButtonDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 18.12.20.
//

import SwiftUI
import VComponents

// MARK: - V Primary Button Demo View
struct VPrimaryButtonDemoView: View {
    // MARK: Properties
    static var navBarTitle: String { "Primary Button" }
    
    @State private var isEnabled: Bool = true
    @State private var isLoading: Bool = false
    @State private var contentType: VPrimaryButtonContent = .title
    @State private var borderType: VPrimaryButtonBorder = .borderless
    
    private var model: VPrimaryButtonModel {
        let defaultModel: VPrimaryButtonModel = .init()
        
        var model: VPrimaryButtonModel = .init()

        if borderType == .bordered {
            model.layout.borderWidth = 2

            model.colors.background = .init(
                enabled: .init("PrimaryButtonBordered.Background.enabled"),
                pressed: .init("PrimaryButtonBordered.Background.pressed"),
                disabled: .init("PrimaryButtonBordered.Background.disabled"),
                loading: .init("PrimaryButtonBordered.Background.disabled")
            )

            model.colors.border = defaultModel.colors.background
            
            model.colors.title = model.colors.icon
            
            model.colors.icon = defaultModel.colors.background
            
            model.colors.loader = model.colors.icon.disabled
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
            switch contentType {
            case .title: VPrimaryButton(model: model, isLoading: isLoading, action: {}, title: buttonTitle)
            case .iconTitle: VPrimaryButton(model: model, isLoading: isLoading, action: {}, icon: buttonIcon, title: buttonTitle)
            case .custom: VPrimaryButton(model: model, isLoading: isLoading, action: {}, content: { buttonIcon })
            }
        })
            .disabled(!isEnabled)
    }
    
    @ViewBuilder private func settings() -> some View {
        VSegmentedPicker(
            selection: .init(
                get: { VPrimaryButtonState(isEnabled: isEnabled, isLoading: isLoading) },
                set: { state in
                    isEnabled = state != .disabled // Loading is also type of disabled
                    isLoading = state == .loading
                }
            ),
            headerTitle: "State"
        )
        
        VSegmentedPicker(selection: $contentType, headerTitle: "Content")
        
        VSegmentedPicker(selection: $borderType, headerTitle: "Border")
    }
    
    private var buttonIcon: Image { .init(systemName: "swift") }
    
    private var buttonTitle: String { "Lorem Ipsum" }
}

// MARK: - Helpers
private enum VPrimaryButtonState: Int, VPickableTitledItem {
    case enabled
    case disabled
    case loading
    
    var pickerTitle: String {
        switch self {
        case .enabled: return "Enabled"
        case .disabled: return "Disabled"
        case .loading: return "Loading"
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

enum VPrimaryButtonContent: Int, VPickableTitledItem {
    case title
    case iconTitle
    case custom
    
    var pickerTitle: String {
        switch self {
        case .title: return "Title"
        case .iconTitle: return "Icon & Title"
        case .custom: return "Custom"
        }
    }
}

enum VPrimaryButtonBorder: Int, VPickableTitledItem {
    case borderless
    case bordered
    
    var pickerTitle: String {
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
