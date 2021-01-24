//
//  VPlainButtonDemoView.swift
//  VComponentsDemo
//
//  Created by Vakhtang Kontridze on 18.12.20.
//

import SwiftUI
import VComponents

// MARK:- V Plain Button Demo View
struct VPlainButtonDemoView: View {
    // MARK: Properties
    static let navigationBarTitle: String = "Plain Button"
    
    @State private var state: VPlainButtonState = .enabled
    @State private var contentType: ComponentContentType = .text
    @State private var hitBoxType: ButtonComponentHitBoxType = .init(value: VPlainButtonModel.Layout().hitBoxHor)
    
    private var model: VPlainButtonModel {
        let defaultModel: VPlainButtonModel = .init()
        
        var model: VPlainButtonModel = .init()
        
        switch hitBoxType {
        case .clipped:
            model.layout.hitBoxHor = 0
            model.layout.hitBoxVer = 0
            
        case .extended:
            model.layout.hitBoxHor = defaultModel.layout.hitBoxHor.isZero ? 5 : defaultModel.layout.hitBoxHor
            model.layout.hitBoxVer = defaultModel.layout.hitBoxVer.isZero ? 5 : defaultModel.layout.hitBoxVer
        }

        return model
    }
}

// MARK:- Body
extension VPlainButtonDemoView {
    var body: some View {
        VBaseView(title: Self.navigationBarTitle, content: {
            DemoView(component: component, settings: settings)
        })
    }
    
    @ViewBuilder private func component() -> some View {
        switch contentType {
        case .text: VPlainButton(model: model, state: state, action: {}, title: buttonTitle)
        case .icon: VPlainButton(model: model, state: state, action: {}, content: buttonContent)
        }
    }
    
    @ViewBuilder private func settings() -> some View {
        VSegmentedPicker(selection: $state, header: "State")
        
        VSegmentedPicker(selection: $contentType, header: "Content")
        
        VSegmentedPicker(selection: $hitBoxType, header: "Hit Box")
    }
    
    private var buttonTitle: String { "Lorem ipsum" }

    private func buttonContent() -> some View { DemoIconContentView() }
}

// MARK:- Helpers
extension VPlainButtonState: VPickableTitledItem {
    public var pickerTitle: String {
        switch self {
        case .enabled: return "Enabled"
        case .disabled: return "Disabled"
        }
    }
}

// MARK:- Preview
struct VPlainButtonDemoView_Previews: PreviewProvider {
    static var previews: some View {
        VPlainButtonDemoView()
    }
}
