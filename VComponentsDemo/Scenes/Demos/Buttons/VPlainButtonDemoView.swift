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
    
    @State private var state: VPlainButtonState = .enabled
    @State private var contentType: ComponentContentType = .text
    @State private var hitBoxType: ButtonComponentHitBoxType = .init(value: VPlainButtonModel.Layout().hitBox.horizontal)
    
    private var model: VPlainButtonModel {
        let defaultModel: VPlainButtonModel = .init()
        
        var model: VPlainButtonModel = .init()
        
        switch hitBoxType {
        case .clipped:
            model.layout.hitBox.horizontal = 0
            model.layout.hitBox.vertical = 0
            
        case .extended:
            model.layout.hitBox.horizontal = defaultModel.layout.hitBox.horizontal.isZero ? 5 : defaultModel.layout.hitBox.horizontal
            model.layout.hitBox.vertical = defaultModel.layout.hitBox.vertical.isZero ? 5 : defaultModel.layout.hitBox.vertical
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
        case .text: VPlainButton(model: model, state: state, action: {}, title: buttonTitle)
        case .custom: VPlainButton(model: model, state: state, action: {}, content: buttonContent)
        }
    }
    
    @ViewBuilder private func settings() -> some View {
        VSegmentedPicker(selection: $state, headerTitle: "State")
        
        VSegmentedPicker(selection: $contentType, headerTitle: "Content")
        
        VSegmentedPicker(selection: $hitBoxType, headerTitle: "Hit Box")
    }
    
    private var buttonTitle: String { "Lorem ipsum" }

    private func buttonContent() -> some View { DemoIconContentView() }
}

// MARK: - Helpers
extension VPlainButtonState: VPickableTitledItem {
    public var pickerTitle: String {
        switch self {
        case .enabled: return "Enabled"
        case .disabled: return "Disabled"
        @unknown default: fatalError()
        }
    }
}

// MARK: - Preview
struct VPlainButtonDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VPlainButtonDemoView()
    }
}
