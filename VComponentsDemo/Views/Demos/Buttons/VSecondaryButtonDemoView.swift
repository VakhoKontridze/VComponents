//
//  VSecondaryButtonDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 18.12.20.
//

import SwiftUI
import VComponents

// MARK:- V Secondary Button Demo View
struct VSecondaryButtonDemoView: View {
    // MARK: Properties
    static let navBarTitle: String = "Secondary Button"
    
    @State private var state: VSecondaryButtonState = .enabled
    @State private var contentType: ComponentContentType = .text
    @State private var hitBoxType: ButtonComponentHitBoxType = .init(value: VSecondaryButtonModel.Layout().hitBox.horizontal)
    @State private var borderType: ButtonComponentBorderType = .borderless
    
    private var model: VSecondaryButtonModel {
        let defaultModel: VSecondaryButtonModel = .init()
        
        var model: VSecondaryButtonModel = .init()
        
        switch hitBoxType {
        case .clipped:
            model.layout.hitBox.horizontal = 0
            model.layout.hitBox.vertical = 0
            
        case .extended:
            model.layout.hitBox.horizontal = defaultModel.layout.hitBox.horizontal.isZero ? 5 : defaultModel.layout.hitBox.horizontal
            model.layout.hitBox.vertical = defaultModel.layout.hitBox.vertical.isZero ? 5 : defaultModel.layout.hitBox.vertical
        }

        if borderType == .bordered {
            model.layout.borderWidth = 1
            
            model.colors.textContent = .init(
                enabled: defaultModel.colors.background.enabled,
                pressed: defaultModel.colors.background.pressed,
                disabled: defaultModel.colors.background.disabled
            )
            
            model.colors.background = .init(
                enabled: .init("PrimaryButtonBordered.Background.enabled"),
                pressed: .init("PrimaryButtonBordered.Background.pressed"),
                disabled: .init("PrimaryButtonBordered.Background.disabled")
            )
            
            model.colors.border = .init(
                enabled: defaultModel.colors.background.enabled,
                pressed: defaultModel.colors.background.disabled,   // It's better this way
                disabled: defaultModel.colors.background.disabled
            )
        }

        return model
    }
}

// MARK:- Body
extension VSecondaryButtonDemoView {
    var body: some View {
        VBaseView(title: Self.navBarTitle, content: {
            DemoView(component: component, settings: settings)
        })
    }
    
    @ViewBuilder private func component() -> some View {
        switch contentType {
        case .text: VSecondaryButton(model: model, state: state, action: {}, title: buttonTitle)
        case .custom: VSecondaryButton(model: model, state: state, action: {}, content: buttonContent)
        }
    }
    
    @ViewBuilder private func settings() -> some View {
        VSegmentedPicker(selection: $state, headerTitle: "State")
        
        VSegmentedPicker(selection: $contentType, headerTitle: "Content")
        
        VSegmentedPicker(selection: $hitBoxType, headerTitle: "Hit Box")
        
        VSegmentedPicker(selection: $borderType, headerTitle: "Border")
    }
    
    private var buttonTitle: String { "Lorem ipsum" }

    private func buttonContent() -> some View {
        let color: Color = {
            switch borderType {
            case .bordered: return VSecondaryButtonModel().colors.background.enabled
            case .borderless: return ColorBook.primaryInverted
            }
        }()
        
        return DemoIconContentView(color: color)
    }
}

// MARK:- Helpers
extension VSecondaryButtonState: VPickableTitledItem {
    public var pickerTitle: String {
        switch self {
        case .enabled: return "Enabled"
        case .disabled: return "Disabled"
        @unknown default: fatalError()
        }
    }
}

enum ButtonComponentHitBoxType: Int, VPickableTitledItem {
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

// MARK:- Preview
struct VSecondaryButtonDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VSecondaryButtonDemoView()
    }
}
