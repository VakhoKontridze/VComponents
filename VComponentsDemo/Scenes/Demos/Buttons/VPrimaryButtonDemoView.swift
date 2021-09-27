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
    static let navBarTitle: String = "Primary Button"
    
    @State private var state: VPrimaryButtonState = .enabled
    @State private var contentType: ComponentContentType = .text
    @State private var borderType: ButtonComponentBorderType = .borderless
    
    private var model: VPrimaryButtonModel {
        let defaultModel: VPrimaryButtonModel = .init()
        
        var model: VPrimaryButtonModel = .init()

        if borderType == .bordered {
            model.layout.borderWidth = 1
            
            model.colors.textContent = .init(
                enabled: defaultModel.colors.background.enabled,
                pressed: defaultModel.colors.background.pressed,
                disabled: defaultModel.colors.background.disabled,
                loading: defaultModel.colors.background.loading
            )
            
            model.colors.background = .init(
                enabled: .init("PrimaryButtonBordered.Background.enabled"),
                pressed: .init("PrimaryButtonBordered.Background.pressed"),
                disabled: .init("PrimaryButtonBordered.Background.disabled"),
                loading: .init("PrimaryButtonBordered.Background.disabled")
            )
            
            model.colors.border = .init(
                enabled: defaultModel.colors.background.enabled,
                pressed: defaultModel.colors.background.disabled,   // It's better this way
                disabled: defaultModel.colors.background.disabled,
                loading: defaultModel.colors.background.loading
            )
        }

        return model
    }

    // MARK: Body
    var body: some View {
        VBaseView(title: Self.navBarTitle, content: {
            DemoView(component: component, settings: settings)
        })
    }
    
    @ViewBuilder private func component() -> some View {
        switch contentType {
        case .text: VPrimaryButton(model: model, state: state, action: {}, title: buttonTitle)
        case .custom: VPrimaryButton(model: model, state: state, action: {}, content: buttonContent)
        }
    }
    
    @ViewBuilder private func settings() -> some View {
        VSegmentedPicker(selection: $state, headerTitle: "State")
        
        VSegmentedPicker(selection: $contentType, headerTitle: "Content")
        
        VSegmentedPicker(selection: $borderType, headerTitle: "Border")
    }
    
    private var buttonTitle: String { "Lorem ipsum" }

    private func buttonContent() -> some View {
        let color: Color = {
            switch borderType {
            case .bordered: return VPrimaryButtonModel().colors.background.enabled
            case .borderless: return ColorBook.primaryInverted
            }
        }()
        
        return DemoIconContentView(dimension: 20, color: color)
    }
}

// MARK: - Helpers
extension VPrimaryButtonState: VPickableTitledItem {
    public var pickerTitle: String {
        switch self {
        case .enabled: return "Enabled"
        case .disabled: return "Disabled"
        case .loading: return "Loading"
        @unknown default: fatalError()
        }
    }
}

enum ComponentContentType: Int, VPickableTitledItem {
    case text
    case custom
    
    var pickerTitle: String {
        switch self {
        case .text: return "Text"
        case .custom: return "Custom"
        }
    }
}

enum ButtonComponentBorderType: Int, VPickableTitledItem {
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
